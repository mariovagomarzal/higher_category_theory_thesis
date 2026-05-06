/// This module defines the acknowledgements page and the colophon (copyright notice) of the thesis.
#import "langs/translations.typ": translate
#import "colors.typ": palette
#import "fonts.typ": font-families, font-styles, sans-ratio
#import "layout.typ": margins, _blank-page

/// Font sizes used by the acknowledgements page.
#let _acknowledgements-font-sizes = (
  acknowledgements: 15pt,
  copyright: 11pt,
)

/// Renders the copyright line with the year and the list of author names.
///
/// -> content
#let _copyright-line(
  /// Author entries normalised to dictionaries with `name` and `affiliation` keys.
  /// -> array
  authors,
  /// The reference date used to extract the copyright year.
  /// -> datetime
  date,
) = (sym.copyright, date.display("[year]"), authors.map(author => author.name).join(", ")).join(" ")

/// Renders the version, location, and date footer line of the colophon.
///
/// -> content
#let _copyright-footer(
  /// The thesis version.
  /// -> str | content
  version,
  /// The defence location.
  /// -> str | content
  location,
  /// The reference date used to render the month and year.
  /// -> datetime
  date,
) = (version, location, date.display("[month repr:long] [year]")).join([ · ])

/// Renders the acknowledgements page along with the colophon block at the bottom.
///
/// -> content
#let acknowledgements-page(
  /// The acknowledgements text.
  /// -> str | content
  acknowledgements: [],
  /// The thesis title displayed in the colophon.
  /// -> str | content
  title: [],
  /// Author entries normalised to dictionaries with `name` and `affiliation` keys.
  /// -> array
  authors: (),
  /// The copyright/license notice displayed in the colophon.
  /// -> str | content
  copyright: [],
  /// The thesis version.
  /// -> str | content
  version: [],
  /// The defence location.
  /// -> str | content
  location: [],
  /// The reference date used in the copyright line and footer.
  /// -> datetime
  date: datetime.today(),
  /// The output mode (`"digital"` or `"print"`).
  /// -> str
  output: "digital",
) = {
  _blank-page(output, weak: true)

  // Create an invsible level 1 heading to appear in the outline.
  {
    show heading.where(level: 1): it => {}

    heading(
      level: 1,
      numbering: none,
      outlined: true,
      translate("Acknowledgements"),
    )
  }

  set page(
    margin: margins.normal,
    header: none,
    footer: none,
  )

  set par(
    justify: false,
    leading: 0.8em,
    first-line-indent: 0pt,
  )

  align(
    center,
    block(
      above: 2fr,
      below: 1fr,
      width: 50%,
      text(
        ..font-styles.normal,
        size: _acknowledgements-font-sizes.acknowledgements,
        style: "italic",
        acknowledgements,
      )
    ),
  )

  block(
    width: 70%,
    {
      set text(
        ..font-families.sans,
        size: _acknowledgements-font-sizes.copyright * sans-ratio,
      )

      title

      parbreak()

      text(
        fill: palette.text-muted,
        [
          #_copyright-line(authors, date)

          #copyright

          #_copyright-footer(version, location, date)
        ],
      )
    },
  )

  _blank-page(output, weak: true)
}
