/// This module defines an alternative title page in the style of the Universitat de València final-project cover.
#import "../langs/translations.typ": translate
#import "../colors.typ": palette
#import "../fonts.typ": font-styles
#import "../layout.typ": margins, _blank-page

/// The university logo displayed at the top of the title page.
#let university-logo = image("assets/logo.svg")

/// The faculty logo displayed alongside the degree at the bottom of the title page.
#let faculty-logo = image("assets/faculty.svg", width: 70%)

/// Font sizes used by the title page.
#let _title-page-font-sizes = (
  work-type: 16pt,
  title: 26pt,
  authors: 16pt,
  supervisors: 14pt,
  degree: 14pt,
)

/// Spacing and layout dimensions used by the title page.
#let _title-page-skips = (
  university-gap: 50pt,
  work-type-gap: 60pt,
  authors-lines-gap: 70pt,
  authors-gap: 12pt,
  faculty-gap: 10pt,
)

/// Builds an authors-like line of the title page, picking the singular or plural label according to the list length
/// and joining the names in small caps with commas.
///
/// -> content
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
) = [
  #translate(if authors.len() > 1 { plural } else { singular }):
  #authors.map(author => smallcaps(author.name)).join(", ")
]

/// Renders an alternative thesis title page reminiscent of the Universitat de València final-project cover.
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

  set align(center)

  v(_title-page-skips.university-gap)

  block(university-logo)

  block(
    spacing: 1fr,
    {
      block(
        spacing: _title-page-skips.work-type-gap,
        text(
          size: _title-page-font-sizes.work-type,
          [#work-type --- #academic-year],
        ),
      )

      block(
        width: 85%,
        text(
          size: _title-page-font-sizes.title,
          fill: palette.text,
          title,
        ),
      )

      block(
        spacing: _title-page-skips.authors-lines-gap,
        {
          block(
            spacing: _title-page-skips.authors-gap,
            text(
              size: _title-page-font-sizes.authors,
              _authors-row("Author", "Authors", authors),
            ),
          )

          block(
            spacing: _title-page-skips.authors-gap,
            text(
              size: _title-page-font-sizes.supervisors,
              _authors-row("Supervisor", "Supervisors", supervisors),
            ),
          )
        }
      )
    }
  )

  block(
    above: 1fr,
    {
      line(
        length: 100%,
        stroke: 0.5pt + palette.text,
      )

      block(
        spacing: _title-page-skips.faculty-gap,
        grid(
          columns: (1fr, 1fr),
          align: (left + horizon, right + horizon),
          faculty-logo,
          text(
            size: _title-page-font-sizes.degree,
            degree,
          ),
        ),
      )
    }
  )

  _blank-page(output, weak: true)
}
