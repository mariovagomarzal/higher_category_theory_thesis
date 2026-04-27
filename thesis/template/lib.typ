/// Thesis template entry point.
#import "colors.typ": palette
#import "layout.typ": _layout-setup
#import "fonts.typ": text-fonts, sans-serif, _fonts-setup

/// Auxiliary function to format a single author/supervisor entry.
///
/// - author (str | content | dict): The author/supervisor to format. Can be a string, content, or a dictionary with
///   name and affiliation.
///
/// -> dict
#let _format-author(author) = {
  if type(author) == str or type(author) == content {
    return (name: author, affiliation: none)
  } else if type(author) == dict {
    return (name: author.name, affiliation: author.affiliation) // FIXME: Don't assume the keys exist.
  } else {
    error("Invalid author/supervisor format")
  }
}

/// Auxiliary function to format author/supervisor information.
///
/// - authors (str | content | dict | array): The author(s) to format. Can be a string, content, dictionary with name
///   and affiliation, or an array of any of those.
///
/// -> array
#let _format-authors(authors) = {
  if type(authors) != array {
    return (_format-author(authors),)
  } else {
    return authors.map(_format-author)
  }
}

/// Auxiliary function to format a list of authors/supervisors into a list of strings with only the names.
///
/// - authors (array): An array of dictionaries with name and affiliation.
///
/// -> array
#let _authors-names(authors) = {
  return authors.map(author => author.name)
}

/// Main thesis template function.
///
/// - title (str | content): The title of the thesis.
/// - author (str | content | dict | array): The author(s) of the thesis. Can be a string, content, dictionary with name
///   and affiliation, or an array of any of those.
/// - supervisor (str | content | dict | array): The supervisor(s) of the thesis. Can be a string, content, dictionary
///   with name and affiliation, or an array of any of those.
/// - description (str | content): A short description of the thesis.
/// - date (auto | datetime): The date of the thesis. If set to auto, it will use the current date.
/// - location (str | content): The location where the thesis was defended.
/// - university (str | content): The university where the thesis was defended.
/// - department (str | content): The department of the university where the thesis was defended.
/// - degree (str | content): The degree for which the thesis was submitted.
/// - lang (str): The language of the thesis (default: "en").
/// - body (content): The main content of the thesis.
///
/// -> content
#let thesis(
  title: none,
  author: (),
  supervisor: (),
  description: none,
  date: auto,
  location: none,
  university: none,
  department: none,
  degree: none,
  lang: "en",
  body,
) = {
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
  show: _layout-setup
  show: _fonts-setup

  body
}
