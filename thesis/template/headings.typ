/// This module defines heading styles and the chapter page layout for the thesis.
#import "colors.typ": palette
#import "fonts.typ": font-families, font-sizes, sans-ratio, font-styles
#import "layout.typ": _blank-page, _is-chapter-page
#import "num2words.typ": num2words

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
  chapter-page-before: 30%,
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
    text(
      ..font-styles.ui,
      size: _number-size(title-size),
      counter(heading).display(it.numbering),
    )

    h(_heading-skips.heading-number-gap)

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
#let _chapter(output, it) = _blank-page(output, weak: true) + block(
  below: _heading-skips.chapter-after,
  {
    let is-numbered = it.numbering != none

    let heading-number = {
      if is-numbered {
        let heading-counter = counter(heading)

        (text(
          ..font-styles.ui,
          size: _heading-font-sizes.chapter-label,
          upper[#it.supplement #num2words(heading-counter.get().at(0))],
        ))

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
    
    if _is-chapter-page.get() {
      v(_heading-skips.chapter-page-before)
    } else {
      v(_heading-skips.chapter-before)
    }

    heading-number
    v(_heading-skips.chapter-title-gap, weak: true)
    heading-title
  },
)

/// Renders a section heading with the section symbol, number, and title.
///
/// -> content
#let _section(it) = block(
  above: _heading-skips.section-before,
  below: _heading-skips.section-after,
  {
    text(
      ..font-styles.ui,
      size: _number-size(_heading-font-sizes.section-title),
      [#sym.section #counter(heading).display(it.numbering)],
    )

    v(_heading-skips.section-title-gap, weak: true)

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
  // General settings for all headings.
  set heading(
    numbering: "1.1.1",
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
  show heading.where(level: 1): set heading(supplement: [Chapter]) // TODO: Make it language-aware.

  show heading.where(level: 1): it => _chapter(output, it)

  // Sections: level 2 headings.
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

    v(_heading-skips.chapter-quote-gap, weak: true)

    block(
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

  _is-chapter-page.update(false)

  pagebreak(weak: true)
}
