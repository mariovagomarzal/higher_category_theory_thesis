/// This module defines the font families and configures text settings for the thesis.
#import "colors.typ": palette

/// Font families used throughout the thesis.
#let font-families = (
  serif: (
    font: "EB Garamond 12",
    number-type: "lining",
  ),
  serif-small: (
    font: "EB Garamond 08",
    number-type: "lining",
  ),
  sans: (
    font: "Fira Sans",
  ),
  sans-small: (
    font: "Fira Sans",
  ),
  math: (
    font: "Garamond-Math",
  ),
  monospace: (
    font: "JuliaMono",
  ),
)

/// Font sizes used throughout the thesis.
#let font-sizes = (
  normal: 11pt,
  caption: 10pt,
  raw: 10pt,
  footnote: 9pt,
)

/// Scaling factor applied to sans-serif font sizes so they appear optically matched to the serif text.
#let sans-ratio = 0.8

/// Sacaling factor applied to monospace font sizes so they appear optically matched to the serif text.
#let monospace-ratio = 0.85

/// Font styles used throughout the thesis.
#let font-styles = (
  normal: (
    ..font-families.serif,
    fill: palette.text,
  ),
  quote: (
    ..font-families.serif,
    style: "italic",
    fill: palette.text-muted,
  ),
  ui: (
    ..font-families.sans,
    weight: "light",
    tracking: 1pt,
    fill: palette.text-muted,
  ),
)

/// Applies the font settings for the thesis.
///
/// -> content
#let _fonts-setup(
  /// The content to apply font settings to.
  /// -> content
  body,
) = {
  // Normal text font settings.
  set text(
    ..font-styles.normal,
    size: font-sizes.normal,
    fallback: false,
  )

  // Caption text font settings.
  show figure.caption: set text(
    ..font-styles.normal,
    size: font-sizes.caption,
  )

  // Footnote text font settings.
  show footnote.entry: set text(
    ..font-families.serif-small,
    size: font-sizes.footnote,
  )

  // Math font settings.
  show math.equation: set text(
    ..font-families.math,
  )

  // Raw block font settings.
  show raw: set text(
    ..font-families.monospace,
    size: font-sizes.raw * monospace-ratio,
  )

  body
}
