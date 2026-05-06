/// This module defines the bibliography style for the thesis.
#import "langs/translations.typ": translate

/// TODO: Comment.
#let _bibliography-setup(
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
