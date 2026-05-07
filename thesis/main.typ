#import "/template/lib.typ": thesis
#import "/translations.typ": (
  titles,
  subtitles,
  descriptions,
  work-types,
  defences,
  faculties,
  departments,
  degrees,
  copyrights,
  abstracts,
)

#let lang = sys.inputs.lang
#let output = sys.inputs.output

#let content-file(lang, path) = "/" + lang + "-contents/" + path

#set text(lang: lang)

#show: thesis.with(
  title: titles.at(lang),
  subtitle: subtitles.at(lang),
  author: "Mario Vago Marzal",
  supervisor: ("Enric Cosme Llópez", "Raúl Ruiz Mora"),
  description: descriptions.at(lang),
  date: auto,
  work-type: work-types.at(lang),
  academic-year: [2025--2026],
  defence: defences.at(lang),
  version: "0.1.0",
  location: text(lang: "ca", [València]),
  university: text(lang: "ca", [Universitat de València]),
  faculty: faculties.at(lang),
  department: departments.at(lang),
  degree: degrees.at(lang),
  acknowledgements: text(lang: "ca", [
    A la meua família,
    #linebreak()
    ---
    #linebreak()
    per ensenyar-me que les que es construeixen amb cura duren més que les que es proven sense.
  ]),
  copyright: copyrights.at(lang),
  abstract: abstracts,
  output: output,
)

#include content-file(lang, "introduction.typ")

#bibliography("bibliography.yaml")
