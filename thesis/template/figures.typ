/// This module configures figure (figure, table, listing) numbering and caption styling for the thesis.
#import "@preview/i-figured:0.2.4": reset-counters, show-figure, show-equation
#import "fonts.typ": font-sizes

/// Spacing values for figure elements.
#let _figures-skips = (
  figure-gap: 20pt,
  figure-caption-gap: 10pt,
)

/// Renders a figure caption with its supplement, number, and body in small caps.
///
/// -> content
#let _figure-caption(
  /// The figure caption element to render.
  /// -> dict
  it,
) = {
  v(_figures-skips.figure-caption-gap)
  
  smallcaps[#it.supplement~#it.counter.display(it.numbering)]
  it.separator
  it.body
}

/// Applies figure styles for the thesis using the 'i-figured' package.
///
/// -> content
#let _figures-setup(
  /// The content to apply figure styles to.
  /// -> content
  body,
) = {
  // Reset the figure counters at every chapter and section (level 1 and 2 headings).
  show heading: reset-counters.with(
    level: 2,
    equations: true,
    return-orig-heading: true,
  )

  // Set the numbering format for figures.
  show figure: show-figure.with(
    level: 2,
    numbering: "1.1.1",
    zero-fill: false,
    leading-zero: false,
    fallback-prefix: "fig:",
  )

  // Set the numbering format for equations.
  show math.equation: show-equation.with(
    level: 2,
    numbering: "(1.1.1)",
    zero-fill: false,
    leading-zero: false,
    prefix: "eq:",
    only-labeled: true,
  )

  // Set caption styling for figures.
  show figure: set block(spacing: _figures-skips.figure-gap)

  show figure.caption: set par(
    justify: false,
    first-line-indent: 0pt,
  )

  set figure.caption(
    position: bottom,
    separator: [. ],
  )

  show figure.caption: _figure-caption

  body
}
