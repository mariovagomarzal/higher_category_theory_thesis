/// Fonts module for the thesis template.
#import "colors.typ": palette

/// Font families used throughout the thesis.
#let text-fonts = (
  serif: "EB Garamond 12",
  serif-small: "EB Garamond 08",
  math: "Garamond-Math",
  sans: "Inter",
)

/// Wraps content in the sans-serif font.
///
/// -> content
#let sans-serif(
  /// The content to render in sans-serif.
  /// -> content
  body,
) = text(font: text-fonts.sans, body)

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
    font: text-fonts.serif,
    fallback: false,
    size: 11pt,
    fill: palette.text,
    number-type: "lining", // Force "lining" when using EB Garamond.
  )

  // Footnote text font settings.
  show footnote.entry: set text(
    font: text-fonts.serif-small,
    size: 9pt,
  )

  // Math font settings.
  show math.equation: set text(
    font: text-fonts.math,
  )

  body
}
