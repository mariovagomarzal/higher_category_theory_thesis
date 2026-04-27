/// Layout module for the thesis template.

/// Applies layout settings for the thesis.
///
/// - body (content): The content to apply layout settings to.
///
/// -> content
#let _layout-setup(body) = {
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
