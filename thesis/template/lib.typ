/// Thesis template entry point.
#import "langs/translations.typ": translate, translations
#import "colors.typ": palette
#import "fonts.typ": (
  font-families,
  font-sizes,
  sans-ratio,
  font-styles,
  _fonts-setup
)
#import "layout.typ": _blank-page, margins, _layout-setup
#import "headings.typ": _headings-setup, chapter
#import "title-page.typ": title-page
#import "acknowledgements.typ": acknowledgements-page
#import "abstracts.typ": abstracts
#import "outline.typ": outline-page

/// Auxiliary function to format a single author/supervisor entry.
///
/// -> dict
#let _format-author(
  /// The author/supervisor to format. Can be a string, content, or a dictionary with name and affiliation.
  /// -> str | content | dict
  author,
) = if type(author) == str or type(author) == content {
  (name: author, affiliation: none)
} else if type(author) == dict {
  (
    name: author.at("name", default: none),
    affiliation: author.at("affiliation", default: none),
  )
} else {
  panic("Invalid author/supervisor format")
}

/// Auxiliary function to format author/supervisor information.
///
/// -> array
#let _format-authors(
  /// The author(s) to format. Can be a string, content, dictionary with name and affiliation, or an array of any
  /// of those.
  /// -> str | content | dict | array
  authors,
) = if type(authors) != array {
  (_format-author(authors),)
} else {
  authors.map(_format-author)
}

/// Auxiliary function to format a list of authors/supervisors into a list of strings with only the names.
///
/// -> array
#let _authors-names(
  /// An array of dictionaries with name and affiliation.
  /// -> array
  authors,
) = authors.map(author => author.name)

/// Auxiliary function to format a date according to a given format string. If the date is `auto`, the current date
/// is used. If the date is not a `datetime`, it is returned as-is.
///
/// -> str | content
#let _date-display(
  /// The date to format. If set to `auto`, the current date will be used.
  /// -> auto | datetime | str | content
  date,
  /// The format string used when `date` is a `datetime` (see Typst's `datetime.display`).
  /// -> str
  format,
) = {
  if date == auto {
    date = datetime.today()
  }

  if type(date) == datetime {
    return date.display(format)
  } else {
    return date
  }
}

/// Main thesis template function.
///
/// -> content
#let thesis(
  /// The title of the thesis.
  /// -> str | content
  title: [],
  /// The subtitle of the thesis.
  /// -> str | content
  subtitle: [],
  /// The author(s) of the thesis. Can be a string, content, dictionary with name and affiliation, or an array of
  /// any of those.
  /// -> str | content | dict | array
  author: (),
  /// The supervisor(s) of the thesis. Can be a string, content, dictionary with name and affiliation, or an array
  /// of any of those.
  /// -> str | content | dict | array
  supervisor: (),
  /// A short description of the thesis.
  /// -> str | content
  description: [],
  /// The date of the document. If set to `auto`, the current date will be used.
  /// -> auto | datetime
  date: auto,
  /// The type of work (e.g. "Final Project", "Master's Thesis").
  /// -> str | content
  work-type: [],
  /// The academic year of the thesis. If set to `auto`, the current year will be used.
  /// -> auto | datetime | str | content,
  academic-year: auto,
  /// The date of the thesis defence. If set to `auto`, the current date will be used.
  /// -> auto | datetime | str | content,
  defence: auto,
  /// The version of the thesis.
  /// -> str | content
  version: [],
  /// The location where the thesis was defended.
  /// -> str | content
  location: [],
  /// The university where the thesis was defended.
  /// -> str | content
  university: [],
  /// The faculty of the university where the thesis was defended.
  /// -> str | content
  faculty: [],
  /// The department of the university where the thesis was defended.
  /// -> str | content
  department: [],
  /// The degree for which the thesis was submitted.
  /// -> str | content
  degree: [],
  /// The acknowledgements text displayed on its own front matter page.
  /// -> str | content
  acknowledgements: [],
  /// The copyright/license notice displayed in the colophon below the acknowledgements.
  /// -> str | content
  copyright: [],
  /// Abstract entries, each a dictionary with `lang` (language code), `abstract` (body content), and `keywords`
  /// (list of keywords).
  /// -> array
  abstract: (),
  /// The output mode of the thesis. Use `"print"` for print-ready output or `"digital"` for screen reading.
  /// -> str
  output: "digital",
  /// The main content of the thesis.
  /// -> content
  body,
) = {
  // Validate output mode.
  assert(
    output in ("digital", "print",),
    message: "Invalid output mode: expected 'digital' or 'print', got '" + output + "'",
  )

  // Normalize authors and supervisors to arrays of dictionaries with name and affiliation.
  let authors = _format-authors(author)
  let supervisors = _format-authors(supervisor)

  // Normalize document date.
  let document-date = if date == auto {
    datetime.today()
  } else {
    date
  }

  // Normalize academic-year and defence dates.
  let academic-year-content = _date-display(academic-year, "[year]")
  let defence-content = _date-display(defence, "[month repr:long] [day], [year]")

  // Document metadata.
  set document(
    title: title,
    author: _authors-names(authors),
    description: description,
    date: document-date,
  )

  // Other style settings.
  show: _fonts-setup
  show: _layout-setup.with(output: output)
  show: _headings-setup.with(output: output)

  // Front matter elements.
  {
    set page(numbering: "i")

    // Title page.
    title-page(
      title: title,
      subtitle: subtitle,
      work-type: work-type,
      authors: authors,
      supervisors: supervisors,
      academic-year: academic-year-content,
      defence: defence-content,
      version: version,
      location: location,
      university: university,
      faculty: faculty,
      department: department,
      degree: degree,
      output: output,
    )

    // Acknowledgements page.
    acknowledgements-page(
      acknowledgements: acknowledgements,
      title: title,
      authors: authors,
      copyright: copyright,
      version: version,
      location: location,
      date: document-date,
      output: output,
    )

    // Abstract pages.
    abstracts(entries: abstract)

    // Contents page.
    outline-page()

    // Transition to body: break to a fresh recto and reset the page counter.
    // Even though the chapters already start on a fresh recto, this ensures that the page numbering of the first
    // chapter page of the main matter starts on an odd page, as is customary. 
    _blank-page(output, weak: true)
    counter(page).update(1)
  }

  body
}
