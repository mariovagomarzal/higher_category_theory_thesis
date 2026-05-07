/// This module configures code listings styling for the thesis.
#import "@preview/codly:1.3.0" as codly-module: codly-init, codly, local
#import "@preview/codly-languages:0.1.10": codly-languages
#import "colors.typ": palette
#import "fonts.typ": sans-ratio, font-styles

/// Stroke used for the border of code blocks and their headers.
#let _codes-border-stroke = palette.rule + 0.5pt

/// Font size used for the header and language labels of code blocks.
#let _codes-header-size = 10pt

/// Renders text styled as a code-block header label (uppercased, sans-serif UI style).
///
/// -> content
#let _header-label(
  /// The label text to render.
  /// -> str | content
  body,
) = text(
  ..font-styles.ui,
  size: _codes-header-size * sans-ratio,
  upper(body),
)

/// Spacing values for code-block elements.
#let _codes-spacing = (
  lang-outset-x: -4pt,
  lang-outset-y: 4pt,
  lang-icon-gap: 5pt,
  header-inset: 8pt,
)

/// Renders the language tag of a code block, combining the language icon and its label.
///
/// -> content
#let _language-block(
  /// The language name. Provided by codly.
  /// -> str | content
  lang,
  /// The language icon. Provided by codly.
  /// -> content
  icon,
  /// The language color. Provided by codly. Unused here, but accepted to match codly's lang-format signature.
  /// -> color
  color,
) = {
  let language-content = icon + h(_codes-spacing.lang-icon-gap) + _header-label(lang)
  let total-measure = measure(language-content)

  box(
    height: total-measure.height,
    language-content,
  )
}

/// Codly language entry overriding the display of Lean source blocks.
#let _lean-languages-overrides = (
  name: "Lean 4",
  color: black,
  icon: sym.forall,
)

/// Codly language map extending the defaults with thesis-specific overrides.
#let _languages-overrides = codly-languages + (
  lean: _lean-languages-overrides,
  lean4: _lean-languages-overrides,
)

/// Applies code listings styling for the thesis using the 'codly' package.
///
/// -> content
#let _codes-setup(
  /// The content to apply code listings styling to.
  /// -> content
  body,
) = {
  show: codly-init

  codly(
    enabled: true,
    languages: _languages-overrides,
    fill: palette.codes-fill,
    zebra-fill: none,
    stroke: _codes-border-stroke,
    radius: 0pt,
    lang-outset: (
      x: _codes-spacing.lang-outset-x,
      y: _codes-spacing.lang-outset-y,
    ),
    lang-format: _language-block,
    header-cell-args: (
      fill: palette.codes-header,
      stroke: _codes-border-stroke,
      inset: _codes-spacing.header-inset,
    ),
  )

  body
}

/// Wraps a code block in a local codly scope that renders a header label above it.
///
/// -> content
#let raw-header(
  /// The header label to display above the code block.
  /// -> str | content
  header: [],
  /// The code block content.
  /// -> content
  body,
  /// Additional arguments forwarded to codly's `local`.
  ..codly-args,
) = local(
  lang-outset: (
    x: 0pt,
    y: 0pt,
  ),
  header: _header-label(header),
  ..codly-args.named(),
  body
)
