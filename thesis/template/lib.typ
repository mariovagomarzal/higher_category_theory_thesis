/// Thesis template entry point.
#import "colors.typ": palette
#import "layout.typ": margins, _layout-setup
#import "fonts.typ": (
  font-families,
  font-sizes,
  sans-ratio,
  font-styles,
  _fonts-setup
)
#import "headings.typ": _headings-setup, chapter

/// Auxiliary function to format a single author/supervisor entry.
///
/// -> dict
#let _format-author(
  /// The author/supervisor to format. Can be a string, content, or a dictionary with name and affiliation.
  /// -> str | content | dict
  author,
) = {
  if type(author) == str or type(author) == content {
    return (name: author, affiliation: none)
  } else if type(author) == dict {
    return (
      name: author.at("name", default: none),
      affiliation: author.at("affiliation", default: none),
    )
  } else {
    error("Invalid author/supervisor format")
  }
}

/// Auxiliary function to format author/supervisor information.
///
/// -> array
#let _format-authors(
  /// The author(s) to format. Can be a string, content, dictionary with name and affiliation, or an array of any
  /// of those.
  /// -> str | content | dict | array
  authors,
) = {
  if type(authors) != array {
    return (_format-author(authors),)
  } else {
    return authors.map(_format-author)
  }
}

/// Auxiliary function to format a list of authors/supervisors into a list of strings with only the names.
///
/// -> array
#let _authors-names(
  /// An array of dictionaries with name and affiliation.
  /// -> array
  authors,
) = {
  return authors.map(author => author.name)
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
  /// The date of the thesis. If set to auto, it will use the current date.
  /// -> auto | datetime
  date: auto,
  /// The location where the thesis was defended.
  /// -> str | content
  location: [],
  /// The university where the thesis was defended.
  /// -> str | content
  university: [],
  /// The department of the university where the thesis was defended.
  /// -> str | content
  department: [],
  /// The degree for which the thesis was submitted.
  /// -> str | content
  degree: [],
  /// The language of the thesis (default: "en").
  /// -> str
  lang: "en",
  /// The output mode of the thesis. Use `"print"` for print-ready output
  /// (chapters start on odd pages) or `"digital"` for screen reading.
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

  // If date is set to auto, use the current date.
  if date == auto { date = datetime.today() }

  // Document metadata.
  set document(
    title: title,
    author: _authors-names(authors),
    description: description,
    date: date,
  )

  // Language.
  set text(lang: lang)

  // Other style settings.
  show: _layout-setup.with(output: output)
  show: _fonts-setup
  show: _headings-setup.with(output: output)

  body
}
