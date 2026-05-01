/// This module defines heading styles and the chapter page layout for the thesis.
#import "colors.typ": palette
#import "fonts.typ": font-families, font-sizes, sans-ratio
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
  chapter-page-after: 10%,
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

/// Shared text style for UI-like sans-serif elements (heading numbers, chapter labels).
#let _ui-sans-style = (
  ..font-families.sans,
  weight: "light",
  tracking: 1pt,
  fill: palette.text-muted,
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

/// Renders a subsection-style heading (used for levels >= 3).
///
/// -> content
#let _subsection(
  /// The heading element to render.
  /// -> dict
  it,
  /// The font size for the heading title.
  /// -> length
  title-size,
) = {
  v(_heading-skips.heading-before, weak: true)

  block({
    text(
      .._ui-sans-style,
      size: _number-size(title-size),
      counter(heading).display(it.numbering),
    )

    h(_heading-skips.heading-number-gap)

    text(
      size: title-size,
      fill: palette.text,
      it.body,
    )
  })

  v(_heading-skips.heading-after, weak: true)
}

/// State tracking whether the current page is a chapter opening page.
#let is-chapter-page = state("is-chapter-page", false)

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
  show heading: it => _subsection(it, _heading-font-sizes.fallback-title)

  // Chapters: level 1 headings.
  show heading.where(level: 1): set heading(supplement: [Chapter]) // TODO: Make it language-aware.

  show heading.where(level: 1): it => {
    if output == "print" {
      pagebreak(to: "odd", weak: true)
    } else {
      pagebreak(weak: true)
    }

    if is-chapter-page.get() {
      v(_heading-skips.chapter-page-before)
    } else {
      v(_heading-skips.chapter-before)
    }

    let is-numbered = it.numbering != none

    let heading-number = {
      if is-numbered {
        let heading-counter = counter(heading)

        (text(
          .._ui-sans-style,
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

    block({
      heading-number
      v(_heading-skips.chapter-title-gap, weak: true)
      heading-title
    })

    v(_heading-skips.chapter-after, weak: true)
  }

  // Sections: level 2 headings.
  show heading.where(level: 2): it => {
    v(_heading-skips.section-before, weak: true)

    block({
      text(
        .._ui-sans-style,
        size: _number-size(_heading-font-sizes.section-title),
        [#sym.section #counter(heading).display(it.numbering)],
      )

      v(_heading-skips.section-title-gap, weak: true)

      text(
        size: _heading-font-sizes.section-title,
        fill: palette.text,
        it.body,
      )
    })

    v(_heading-skips.section-after, weak: true)
  }

  // Subsections: level 3 headings.
  show heading.where(level: 3): it => _subsection(it, _heading-font-sizes.subsection-title)

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
  is-chapter-page.update(true)

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

    set par(leading: 0.8em)

    set text(fill: palette.text-muted)

    block(width: 60%, {
      text(
        ..font-families.serif,
        size: font-sizes.normal,
        style: "italic",
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
    })
  }

  pagebreak(weak: true)

  is-chapter-page.update(false)

  v(_heading-skips.chapter-page-after)
}
