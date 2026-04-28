/// This module configures page geometry and paragraph settings for the thesis.

/// Applies layout settings for the thesis.
///
/// -> content
#let _layout-setup(
  /// The content to apply layout settings to.
  /// -> content
  body,
) = {
  // Page settings.
  set page(
    paper: "a4",
  )

  // Paragraph settings.
  set par(
    justify: true,
    leading: 0.65em,
    first-line-indent: 1.25em,
  )

  body
}
