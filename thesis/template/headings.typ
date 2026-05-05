/// This module defines heading styles and the chapter page layout for the thesis.
#import "@preview/num2words:0.1.0": num2words
#import "langs/translations.typ": translate
#import "colors.typ": palette
#import "fonts.typ": font-families, font-sizes, sans-ratio, font-styles
#import "layout.typ": _blank-page, _is-chapter-page

/// Font sizes for heading elements.
#let _heading-font-sizes = (
  chapter-label: 8pt,
  chapter-number: 60pt,
  chapter-title: 24pt,
  section-title: 20pt,
  subsection-title: 14pt,
  fallback-title: 12pt,
)

/// Spacing values for heading elements.
#let _heading-skips = (
  chapter-before: 30pt,
  chapter-after: 30pt,
  chapter-label-gap: 15pt,
  chapter-title-gap: 25pt,
  chapter-quote-gap: 30pt,
  section-before: 25pt,
  section-after: 20pt,
  section-title-gap: 12pt,
  heading-before: 20pt,
  heading-after: 15pt,
  heading-number-gap: 8pt,
)

/// Factor to compute the heading number size from its title size.
#let _number-scale = 0.9

/// Computes the number font size for a heading given its title size.
///
/// -> length
#let _number-size(
  /// The font size of the heading title.
  /// -> length
  title-size,
) = sans-ratio * _number-scale * title-size

/// Renders a general heading element with the given font size for the title.
///
/// -> content
#let _heading(
  /// The heading element to render.
  /// -> dict
  it,
  /// The font size for the heading title.
  /// -> length
  title-size,
) = block(
  above: _heading-skips.heading-before,
  below: _heading-skips.heading-after,
  block({
    if it.numbering != none {
      text(
        ..font-styles.ui,
        size: _number-size(title-size),
        counter(heading).display(it.numbering),
      )

      h(_heading-skips.heading-number-gap)
    }

    text(
      size: title-size,
      fill: palette.text,
      it.body,
    )
  }),
)

/// Renders a chapter heading with its label, number, and title.
///
/// -> content
#let _chapter(output, it) = _blank-page(output, weak: true) + {
  let heading-number = {
    if it.numbering != none {
      let heading-counter = counter(heading)

      text(
        ..font-styles.ui,
        size: _heading-font-sizes.chapter-label,
        upper[#it.supplement #num2words(heading-counter.get().at(0))],
      )

      v(_heading-skips.chapter-label-gap, weak: true)

      text(
        size: _heading-font-sizes.chapter-number,
        fill: palette.text,
        heading-counter.display(it.numbering),
      )
    }
  }

  let heading-title = block(
    width: 50%,
    text(
      size: _heading-font-sizes.chapter-title,
      fill: palette.text,
      it.body,
    )
  )

  let above-skip = if _is-chapter-page.get() {
    // In the `chapter` function, we insert another `1fr` vertical space after the quote to center the content
    // vertically in the chapter page.  
    1fr
  } else {
    _heading-skips.chapter-before
  }

   block(
    above: above-skip,
    below: _heading-skips.chapter-after,
    {
      heading-number
      v(_heading-skips.chapter-title-gap, weak: true)
      heading-title
    },
  )
}

/// Renders a section heading with the section symbol, number, and title.
///
/// -> content
#let _section(it) = block(
  above: _heading-skips.section-before,
  below: _heading-skips.section-after,
  {
    if it.numbering != none {
      text(
        ..font-styles.ui,
        size: _number-size(_heading-font-sizes.section-title),
        [#sym.section #counter(heading).display(it.numbering)],
      )

      v(_heading-skips.section-title-gap, weak: true)
    }

    text(
      size: _heading-font-sizes.section-title,
      fill: palette.text,
      it.body,
    )
  },
)

/// Renders a subsection heading using the generic heading layout.
///
/// -> content
#let _subsection(it) = _heading(it, _heading-font-sizes.subsection-title)

/// Applies heading styles for the thesis.
///
/// -> content
#let _headings-setup(
  /// The output mode (`"digital"` or `"print"`).
  /// -> str
  output: "digital",
  /// The content to apply heading styles to.
  /// -> content
  body,
) = {
  // General settings for all headings. We use 'subsection' for the supplement text as it's the lowest level with a
  // specific style.
  set heading(
    numbering: "1.1.1",
    supplement: translate("Subsection"),
  )

  show heading: set par(
    justify: false,
    first-line-indent: 0pt,
  )

  show heading: set text(
    weight: "medium",
  )

  // Fallback show-rule for headings with level higher than 3.
  show heading: it => _heading(it, _heading-font-sizes.fallback-title)

  // Chapters: level 1 headings.
  show heading.where(level: 1): set heading(supplement: translate("Chapter"))

  show heading.where(level: 1): it => _chapter(output, it)

  // Sections: level 2 headings.
  show heading.where(level: 2): set heading(supplement: translate("Section"))

  show heading.where(level: 2): _section

  // Subsections: level 3 headings.
  show heading.where(level: 3): _subsection

  body
}

/// Produces a chapter opening page with title, optional quote, and page break.
///
/// -> content
#let chapter(
  /// The chapter title.
  /// -> content
  title,
  /// An optional epigraph displayed below the title.
  /// -> none | content
  quote: none,
  /// Attribution line for the epigraph.
  /// -> none | content
  author-line: none,
) = {
  _is-chapter-page.update(true)

  heading(
    level: 1,
    title,
  )

  if quote != none {
    line(
      length: 15%,
      stroke: (
        paint: palette.rule,
        thickness: 0.5pt,
      )
    )

    block(
      spacing: _heading-skips.chapter-quote-gap,
      width: 60%, 
      {
        set par(leading: 0.8em)

        set text(fill: palette.text-muted)
        
        text(
          ..font-styles.quote,
          size: font-sizes.normal,
          quote,
        )

        if author-line != none {
          linebreak()
          text(
            ..font-families.sans,
            size: sans-ratio * font-sizes.normal,
            weight: "light",
            [--- #author-line],
          )
        }
      }
    )
  }

  // Close the vertical space inserted before the chapter content by the `_chapter` function.
  v(1fr)

  _is-chapter-page.update(false)

  pagebreak(weak: true)
}
