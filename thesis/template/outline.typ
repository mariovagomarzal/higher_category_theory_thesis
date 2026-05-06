/// This module defines the table of contents page for the thesis.
#import "langs/translations.typ": translate
#import "colors.typ": palette
#import "fonts.typ": sans-ratio, font-styles

/// Font sizes used by the outline.
#let _outline-font-sizes = (
  chapter-entry: 12pt,
  section-entry: 11pt,
)

/// Spacing values for the outline layout.
#let _outline-skips = (
  chapter-entry-before: 10pt,
  chapter-entry-after: 10pt,
  chapter-entry-column: 20pt,
  section-entry-before: 6pt,
  section-entry-after: 6pt,
  section-entry-column: 15pt,
)

/// State tracking whether the next outline entry is the first one, used to draw a stronger top rule.
#let _is-outline-first-entry = state("_is-outline-first-entry", true)

/// Renders a chapter-level outline entry with its prefix, title, and page number, separated by a horizontal rule.
///
/// -> content
#let _chapter-entry(
  /// The outline entry to render.
  /// -> content
  entry,
) = {
  let stroke = if _is-outline-first-entry.get() {
    0.6pt + black
  } else {
    0.4pt + palette.rule
  }

  line(
    length: 100%,
    stroke: stroke,
  )

  let prefix = if entry.element.numbering == none {
    sym.dash.em
  } else {
    entry.prefix()
  }

  let prefix-content = text(
    ..font-styles.ui,
    fill: palette.text,
    size: _outline-font-sizes.chapter-entry * sans-ratio,
    prefix,
  )

  let title-content = text(
    ..font-styles.normal,
    fill: palette.text,
    size: _outline-font-sizes.chapter-entry,
    entry.body(),
  )

  let page-content = text(
    ..font-styles.ui,
    fill: palette.text,
    size: _outline-font-sizes.chapter-entry * sans-ratio,
    entry.page(),
  )

  block(
    above: _outline-skips.chapter-entry-before,
    below: _outline-skips.chapter-entry-after,
    entry.indented(
      prefix-content,
      title-content + h(1fr) + page-content,
      gap: _outline-skips.chapter-entry-column,
    ),
  )

  _is-outline-first-entry.update(false)
}

/// Renders a section-level outline entry with its prefix, title, and page number in a muted style.
///
/// -> content
#let _section-entry(
  /// The outline entry to render.
  /// -> content
  entry,
) = {
  let prefix = if entry.element.numbering == none {
    []
  } else {
    entry.prefix()
  }

  let prefix-content = text(
    ..font-styles.ui,
    size: _outline-font-sizes.section-entry * sans-ratio,
    prefix,
  )

  let title-content = text(
    ..font-styles.normal,
    fill: palette.text-muted,
    size: _outline-font-sizes.section-entry,
    entry.body(),
  )

  let page-content = text(
    ..font-styles.ui,
    fill: palette.text-muted,
    size: _outline-font-sizes.section-entry * sans-ratio,
    entry.page(),
  )

  block(
    above: _outline-skips.section-entry-before,
    below: _outline-skips.section-entry-after,
    entry.indented(
      prefix-content,
      title-content + h(1fr) + page-content,
      gap: _outline-skips.section-entry-column,
    ),
  )
}

/// Dispatches an outline entry to the appropriate renderer based on its level.
///
/// -> content
#let _outline-entry(
  /// The outline entry to render.
  /// -> content
  entry,
) = {
  if entry.level == 1 {
    _chapter-entry(entry)
  } else if entry.level == 2 {
    _section-entry(entry)
  } else {
    entry
  }
}

/// Produces the table of contents page with chapter and section entries.
///
/// -> content
#let outline-page() = {
  show outline: set heading(outlined: true, numbering: none)

  show outline: it => _is-outline-first-entry.update(true) + it

  show outline.entry: _outline-entry

  outline(
    title: translate("Contents"),
    depth: 2,
  )
}
