/// This module defines the font families and configures text settings for the thesis.
#import "colors.typ": palette

/// Font families used throughout the thesis.
#let text-fonts = (
  serif: (
    font: "EB Garamond 12",
    number-type: "lining",
  ),
  serif-small: (
    font: "EB Garamond 08",
    number-type: "lining",
  ),
  sans: (
    font: "Inter",
  ),
  sans-small: (
    font: "Inter",
  ),
  math: (
    font: "Garamond-Math",
  ),
)

/// Wraps content in the sans-serif font.
///
/// -> content
#let sans-serif(
  /// The content to render in sans-serif.
  /// -> content
  body,
) = text(..text-fonts.sans, body)

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
    ..text-fonts.serif,
    fallback: false,
    size: 11pt,
    fill: palette.text,
  )

  // Footnote text font settings.
  show footnote.entry: set text(
    ..text-fonts.serif-small,
    size: 9pt,
  )

  // Math font settings.
  show math.equation: set text(
    ..text-fonts.math,
  )

  body
}
