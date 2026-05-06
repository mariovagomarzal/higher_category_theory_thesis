/// This module defines the bibliography style for the thesis.
#import "langs/translations.typ": translate

/// Applies bibliography styles for the thesis: outlined heading without numbering and a localized title.
///
/// -> content
#let _bibliography-setup(
  /// The content to apply bibliography styles to.
  /// -> content
  body,
) = {
  show bibliography: set heading(
    numbering: none,
    outlined: true,
  )

  set bibliography(
    title: translate("Bibliography"),
  )

  body
}
