/// This module defines the abstract pages of the thesis.
#import "langs/translations.typ": translate
#import "colors.typ": palette
#import "fonts.typ": font-styles, sans-ratio
#import "headings.typ": _heading-skips

/// Font sizes used by the abstract pages.
#let _abstracts-font-sizes = (
  lang-name: 13pt,
  entry-label: 10pt,
)

/// Spacing values for the abstract page layout.
#let _abstracts-skips = (
  lang-label-gap: -_heading-skips.chapter-after / 2,
  body-gap: 25pt,
  rule-gap: 25pt,
  keywords-gap: 12pt,
  keywords-column-gap: 25pt,
)

/// Renders a single abstract page with its localized title, language label, body, separator rule, and keywords.
///
/// -> content
#let _abstract-page(
  /// The language code of the abstract entry.
  /// -> str
  lang,
  /// The abstract body content.
  /// -> content
  abstract,
  /// The list of keywords associated with the abstract.
  /// -> array
  keywords,
  /// Whether the abstract heading appears in the outline.
  /// -> bool
  outlined: false,
) = {
  set text(lang: lang)

  set par(
    justify: true,
    first-line-indent: 0pt,
  )

  heading(level: 1, numbering: none, outlined: outlined, translate("Abstract"))

  v(_abstracts-skips.lang-label-gap)

  block(
    text(
      ..font-styles.ui,
      size: _abstracts-font-sizes.lang-name * sans-ratio,
      upper(translate("lang-name")),
    ),
  )

  block(
    above: _abstracts-skips.body-gap,
    abstract,
  )

  block(
    above: _abstracts-skips.rule-gap,
    line(
      length: 100%,
      stroke: (
        paint: palette.rule,
        thickness: 0.5pt,
      ),
    ),
  )

  block(
    above: _abstracts-skips.keywords-gap,
    grid(
      columns: (auto, 1fr),
      align: left,
      column-gutter: _abstracts-skips.keywords-column-gap,
      text(
        ..font-styles.ui,
        size: _abstracts-font-sizes.entry-label * sans-ratio,
        fill: palette.text,
        upper(translate("Keywords")),
      ),
      keywords.join([ · ]),
    ),
  )
}

/// Renders one abstract page per entry of the given list.
///
/// -> content
#let abstracts(
  /// Abstract entries with `lang`, `abstract`, and `keywords` keys.
  /// -> array
  entries: (),
) = {
  for (pos, entry) in entries.enumerate() {
    _abstract-page(
      entry.lang,
      entry.abstract,
      entry.keywords,
      outlined: pos == 0,
    )
  }
}
