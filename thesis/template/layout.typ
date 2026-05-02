/// This module configures page geometry and paragraph settings for the thesis.
#import "@preview/hydra:0.6.2": hydra
#import "colors.typ": palette
#import "fonts.typ": font-sizes, _ui-font-style
#import "headings.typ": _standalone-chapter-page, _chapter-blank-page

/// Page margins used throughout the thesis.
#let margins = (
  normal: 2.5cm,
  inside: 3cm,
)

/// Hydra display function rendering a chapter.
///
/// -> content
#let _chapter-display(_, candidate) = context {
  if candidate.numbering == none {
    upper(candidate.body)
  } else {
    let chapter-num = counter(heading).at(candidate.location()).at(0)
    upper[#candidate.supplement #chapter-num. #candidate.body]
  }
}

/// Hydra display function rendering a section.
///
/// -> content
#let _section-display(_, candidate) = context {
  if candidate.numbering == none {
    upper(candidate.body)
  } else {
    let nums = counter(heading).at(candidate.location())
    upper[#numbering(candidate.numbering, ..nums) #h(0.5em) #candidate.body]
  }
}

/// Renders a running-header line followed by the separator rule.
///
/// -> content
#let _header(
  /// The content to render on the left side of the header.
  /// -> content
  left,
  /// The content to render on the right side of the header.
  /// -> content
  right,
) = {
  set text(
    .._ui-font-style,
    size: font-sizes.footnote,
  )
  
  left
  h(1fr)
  right

  line(
    length: 100%,
    stroke: (
      paint: palette.rule,
      thickness: 0.3pt,
    ),
  )
}

/// Applies layout settings for the thesis.
///
/// -> content
#let _layout-setup(
  /// The output mode of the thesis ("digital" or "print").
  /// -> str
  output: "digital",
  /// The content to apply layout settings to.
  /// -> content
  body,
) = {
  // Page settings.
  set page(
    paper: "a4",
    margin: if output == "print" {
      (
        inside: margins.inside,
        outside: margins.normal,
        top: margins.normal,
        bottom: margins.normal,
      )
    } else {
      margins.normal
    },
    header: context {
      if not _standalone-chapter-page.get() {
        if output == "print" and calc.even(here().page()) {
          if not _chapter-blank-page.get() {
            _header(
              counter(page).display(),
              hydra(1, display: _chapter-display, book: true),
            )
          };
        } else {
          _header(
            hydra(2, display: _section-display, book: output == "print"),
            counter(page).display(),
          )
        }
      }
    },
  )

  // Paragraph settings.
  set par(
    justify: true,
    leading: 0.65em,
    first-line-indent: 1.25em,
  )

  body
}
