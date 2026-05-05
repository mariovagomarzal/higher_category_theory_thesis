/// This module defines the translations database for the 'transl' package.
#import "@preview/transl:0.2.0": transl

/// Translate a key using the project's translations database. Thin wrapper around the `transl` function that pre-fills
/// its `data` argument.
///
/// -> str | content
#let translate(
  /// Arguments forwarded to `transl` (see the `transl` package documentation).
  /// -> arguments
  ..transl-args,
) = transl(data: yaml("transl.yaml"), ..transl-args)
