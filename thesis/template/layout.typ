/// This module configures page geometry and paragraph settings for the thesis.

/// Page margins used throughout the thesis.
#let margins = (
  normal: 2.5cm,
  inside: 3cm,
)

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
  )

  // Paragraph settings.
  set par(
    justify: true,
    leading: 0.65em,
    first-line-indent: 1.25em,
  )

  body
}
