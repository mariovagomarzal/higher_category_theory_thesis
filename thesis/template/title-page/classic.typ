/// This module defines front matter elements such as the title page, acknowledgements, abstracts and tables of contents
/// for the thesis template.
#import "../langs/translations.typ": translate
#import "../colors.typ": palette
#import "../fonts.typ": sans-ratio, font-styles
#import "../layout.typ": margins, _blank-page

/// Font sizes used by the title page.
#let _title-page-font-sizes = (
  university: 10pt,
  location: 10pt,
  pre-title: 10pt,
  title: 26pt,
  subtitle: 14pt,
  entry-label: 10pt,
)

/// Spacing and layout dimensions used by the title page.
#let _title-page-skips = (
  university-gap: 10pt,
  title-gap: 20pt,
  subtitle-gap: 15pt,
  info-gap: 40pt,
  info-column-gap: 15pt,
  info-row-gap: 15pt,
)

/// Renders an uppercase label used in the info grid of the title page.
///
/// -> content
#let _entry-label(
  /// The label text.
  /// -> str | content
  body,
) = text(
  ..font-styles.ui,
  size: _title-page-font-sizes.entry-label * sans-ratio,
  fill: palette.text,
  upper(body),
)

/// Builds the label/value pair for an authors-like row of the info grid, picking the singular or plural label
/// according to the list length and joining the names with commas.
///
/// -> array
#let _authors-row(
  /// Translation key for the singular form of the label.
  /// -> str
  singular,
  /// Translation key for the plural form of the label.
  /// -> str
  plural,
  /// Author entries normalised to dictionaries with `name` and `affiliation` keys.
  /// -> array
  authors,
) = (
  _entry-label(translate(if authors.len() > 1 { plural } else { singular })),
  authors.map(author => author.name).join(", "),
)

/// Renders the thesis title page.
///
/// -> content
#let title-page(
  /// The thesis title.
  /// -> str | content
  title: [],
  /// The thesis subtitle.
  /// -> str | content
  subtitle: [],
  /// The type of work (e.g. "Final Project", "Master's Thesis").
  /// -> str | content
  work-type: [],
  /// Author entries normalised to dictionaries with `name` and `affiliation` keys.
  /// -> array
  authors: (),
  /// Supervisor entries normalised to dictionaries with `name` and `affiliation` keys.
  /// -> array
  supervisors: (),
  /// The academic year.
  /// -> str | content
  academic-year: [],
  /// The defence date.
  /// -> str | content
  defence: [],
  /// The thesis version.
  /// -> str | content
  version: [],
  /// The defence location.
  /// -> str | content
  location: [],
  /// The university name.
  /// -> str | content
  university: [],
  /// The faculty name.
  /// -> str | content
  faculty: [],
  /// The department name.
  /// -> str | content
  department: [],
  /// The degree name.
  /// -> str | content
  degree: [],
  /// The output mode of the thesis.
  /// -> str
  output: "digital",
) = {
  _blank-page(output, weak: true)

  set page(
    margin: margins.normal,
    header: none,
    footer: none,
  )

  set par(
    justify: false,
    first-line-indent: 0pt,
  )

  block({
    set text(
      ..font-styles.ui,
      size: _title-page-font-sizes.university * sans-ratio,
    )

    text(
      fill: palette.text,
      weight: "regular",
      upper(university),
    )

    v(_title-page-skips.university-gap, weak: true)

    upper(faculty + [ · ] + degree)
  })

  block(
    spacing: 1fr,
    {
      block({
        set text(
          ..font-styles.ui,
          size: _title-page-font-sizes.pre-title * sans-ratio,
        )

        upper(work-type) + [ · ] + academic-year
      })

      block(
        spacing: _title-page-skips.title-gap,
        width: 60%,
        text(
          fill: palette.text,
          size: _title-page-font-sizes.title,
          title,
        )
      )

      block(
        spacing: _title-page-skips.subtitle-gap,
        width: 55%,
        text(
          ..font-styles.quote,
          size: _title-page-font-sizes.subtitle,
          subtitle,
        )
      )

      block(
        spacing: _title-page-skips.info-gap,
        width: 80%,
        grid(
          columns: 2,
          align: left,
          column-gutter: _title-page-skips.info-column-gap,
          row-gutter: _title-page-skips.info-row-gap,
          .._authors-row("Author", "Authors", authors),
          .._authors-row("Supervisor", "Supervisors", supervisors),
          _entry-label(translate("Department")), department,
          _entry-label(translate("Defence")), defence,
        ),
      )
    },
  )

  block({
    set text(
      ..font-styles.ui,
      size: _title-page-font-sizes.location * sans-ratio,
    )

    upper(location)

    h(1fr)

    version
  })

  _blank-page(output, weak: true)
}
