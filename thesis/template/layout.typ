/// This module configures page geometry and paragraph settings for the thesis.
#import "@preview/hydra:0.6.2": hydra
#import "colors.typ": palette
#import "fonts.typ": font-sizes, font-styles

/// State indicating whether the current page is a blank page inserted to force a recto start.
#let _is-blank-page = state("_is-blank-page", false)

/// Inserts a page break, forcing the next page to be a recto in print mode.
///
/// -> content
#let _blank-page(
  /// Whether the page break is weak (skipped if the current page is already empty).
  /// -> bool
  weak: false,
  /// The output mode of the thesis ("digital" or "print").
  /// -> str
  output
) = {
  if output == "print" {
    _is-blank-page.update(true)
    pagebreak(to: "odd", weak: weak)
    _is-blank-page.update(false)
  } else {
    pagebreak(weak: weak)
  }
}

/// State indicating whether the current page is a chapter opening page.
#let _is-chapter-page = state("_is-chapter-page", false)

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
    ..font-styles.ui,
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

/// State storing the format in which page numbers are displayed.
#let _page-display = state("_page-display", "1")

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
      if not _is-chapter-page.get() {
        if output == "print" and calc.even(here().page()) {
          if not _is-blank-page.get() {
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
    footer: none,
  )

  // Paragraph settings.
  set par(
    justify: true,
    leading: 0.65em,
    first-line-indent: 1.25em,
  )

  body
}
