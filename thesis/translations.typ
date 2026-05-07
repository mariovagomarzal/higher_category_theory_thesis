/// This file provides translations for front matter elements of the thesis.

#let _with-lang(content-dict) = {
  let with-lang-dict = (:)

  for (lang, body) in content-dict {
    with-lang-dict.insert(lang, text(lang: lang, body))
  }

  return with-lang-dict
}

#let titles = _with-lang((
  en: [A Formalization of Higher-Order Categories in Lean~4],
  es: [Una Formalización de las Categorías de Orden Superior en Lean~4],
  ca: [Una Formalització de les Categories d'Ordre Superior en Lean~4],
))

#let subtitles = _with-lang((
  en: [On the relation between single-sorted and many-sorted higher-order categories],
  es: [Sobre la relación entre categorías de orden superior de un solo tipo y de muchos tipos],
  ca: [Sobre la relació entre categories d'ordre superior d'un sol tipus i de molts tipus],
))

#let descriptions = (
  en: "Formalization of higher-order categories in the Lean 4 proof assistant.",
  es: "Formalización de las categorías de orden superior en el verificador formal Lean 4.",
  ca: "Formalització de les categories d'ordre superior en el verificador formal Lean 4.",
)

#let work-types = _with-lang((
  en: [Bachelor's Thesis],
  es: [Trabajo de Fin de Grado],
  ca: [Treball de Fi de Grau],
))

#let defences = (
  en: [July 2026],
  es: [Julio de 2026],
  ca: [Juliol de 2026],
)

#let departments = _with-lang((
  en: [Department of Mathematics],
  es: [Departamento de Matemáticas],
  ca: [Departament de Matemàtiques],
))

#let faculties = _with-lang((
  en: [Faculty of Mathematical Sciences],
  es: [Facultad de Ciencias Matemáticas],
  ca: [Facultat de Ciències Matemàtiques],
))

#let degrees = _with-lang((
  en: [Bachelor's Degree in Mathematics],
  es: [Grado en Matemáticas],
  ca: [Grau en Matemàtiques],
))

#let copyrights = (
  en: [
    This work is licensed under the Apache 2.0 License. The accompanying Lean 4 source is released under the same
    license.
  ],
  es: [
    Este trabajo está licenciado bajo la Licencia Apache 2.0. El código fuente de Lean 4 que lo acompaña se publica bajo
    la misma licencia.
  ],
  ca: [
    Aquest treball està llicenciat sota la Llicència Apache 2.0. El codi font de Lean 4 que l'acompanya es publica sota
    la mateixa llicència.
  ],
)

#let _abstract-contents = _with-lang((
  en: [
    Higher-order categories are a generalization of ordinary category theory in which morphisms can exist at multiple
    levels. They play a central role in modern mathematics, particularly in algebraic topology and homotopy theory.

    This work focuses on the single-sorted and many-sorted presentations of higher-order categories, both
    finite-dimensional ($n$-categories) and infinite-dimensional ($omega$-categories). We study the relations between
    categories of different dimensions, as well as the relations between these presentations.

    On the formal side, we develop a formalization in Lean~4 of these definitions and of some of the relations between
    them. Along the way, we discuss implementation aspects of the formalization, including design choices and
    considerations specific to its underlying dependent type theory.
  ],
  es: [
    Las categorías de orden superior son una generalización de la teoría de categorías ordinaria en la que pueden
    existir morfismos a distintos niveles. Tienen un papel central en las matemáticas modernas, especialmente en
    topología algebraica y teoría de la homotopía.

    Este trabajo se centra en las presentaciones de un solo tipo y de muchos tipos de las categorías de orden superior,
    tanto finitas ($n$-categorías) como infinitas ($omega$-categorías). Estudiamos las relaciones entre categorías de
    distintas dimensiones, así como las relaciones entre estas presentaciones.

    En el plano formal, desarrollamos una formalización en Lean~4 de estas definiciones y de algunas de las relaciones
    entre ellas. A lo largo del trabajo se discuten aspectos de la implementación, como elecciones de diseño y
    consideraciones propias de su teoría de tipos dependiente subyacente.
  ],
  ca: [
    Les categories d'ordre superior són una generalització de la teoria de categories ordinària en la qual poden
    existir morfismes a diferents nivells. Tenen un paper central en les matemàtiques modernes, especialment en
    topologia algebraica i teoria de l'homotopia.

    Aquest treball se centra en les presentacions d'un sol tipus i de molts tipus de les categories d'ordre superior,
    tant finites ($n$-categories) com infinites ($omega$-categories). Estudiem les relacions entre categories de
    diferents dimensions, així com les relacions entre aquestes presentacions.

    Pel que fa a la part formal, desenvolupem una formalització en Lean~4 d'aquestes definicions i d'algunes de les
    relacions entre elles. Al llarg del treball es discuteixen aspectes de la implementació, com ara eleccions de
    disseny i consideracions pròpies de la seva teoria de tipus dependent subjacent.
  ],
))

#let _abstract-keywords = (
  en: ("higher-order categories", "formalization", "Lean~4"),
  es: ("categorías de orden superior", "formalización", "Lean~4"),
  ca: ("categories d'ordre superior", "formalització", "Lean~4"),
)

#let abstracts = (
  (
    lang: "en",
    abstract: _abstract-contents.en,
    keywords: _abstract-keywords.en,
  ),
  (
    lang: "es",
    abstract: _abstract-contents.es,
    keywords: _abstract-keywords.es,
  ),
  (
    lang: "ca",
    abstract: _abstract-contents.ca,
    keywords: _abstract-keywords.ca,
  )
)
