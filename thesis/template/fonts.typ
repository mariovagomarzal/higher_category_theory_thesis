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
)

/// Scaling factor applied to sans-serif font sizes so they appear optically matched to the serif text.
#let sans-ratio = 0.8

/// Font sizes used throughout the thesis.
#let font-sizes = (
  normal: 11pt,
  footnote: 9pt,
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
    ..font-families.serif,
    size: font-sizes.normal,
    fill: palette.text,
    fallback: false,
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

  body
}
