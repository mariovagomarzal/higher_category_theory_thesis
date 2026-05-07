/// This module defines the theorem environments for the thesis.
#import "@preview/theorion:0.6.0" as theorion: (
  indent-repairer,
  indent-fakepar,
  make-frame,
  theorion-i18n-map,
  set-zero-fill,
  set-leading-zero,
  set-theorion-numbering,
  set-indent-mode,
)
#import "langs/translations.typ": translate
#import "fonts.typ": font-styles
#import "layout.typ": par-spacing

/// Vertical spacing between consecutive theorem-like blocks.
#let _theorem-gap = par-spacing.leading * 2

/// Generic renderer for theorem-like frames. Used as the `render` callback of theorion's `make-frame`, which supplies
/// `prefix`, `title`, `full-title` and `body` internally.
///
/// -> content
#let _render-theorem(
  /// The prefix of the frame. Provided by theorion. Unused here, but accepted to match theorion's render signature.
  /// -> content
  prefix: none,
  /// The user-provided title of the frame. Provided by theorion. Unused here, but accepted to match theorion's render
  /// signature.
  /// -> str | content
  title: "",
  /// The full title of the frame (prefix, number, and optional title). Provided by theorion.
  /// -> content
  full-title: auto,
  /// Function applied to `full-title` to style the heading of the frame.
  /// -> function
  render-full-title: smallcaps,
  /// Function applied to `body` to style the contents of the frame.
  /// -> function
  render-body: emph,
  /// The body of the frame. Provided by theorion.
  /// -> content
  body,
) = context {
  block(
    spacing: _theorem-gap,
    indent-repairer({
      set text(..font-styles.normal)

      render-full-title(full-title) + [. ] + render-body(body)
    }),
  )
  indent-fakepar
}

/// Renderer for definition-like frames: upright body instead of emphasized.
#let _render-definition = _render-theorem.with(
  render-body: text.with(..font-styles.normal),
)

/// Renderer for remark-like frames: emphasized full title and upright body.
#let _render-remark = _render-theorem.with(
  render-full-title: emph,
  render-body: text.with(..font-styles.normal),
)

// Theorem-like environments.

/// Theorem environment. Resets numbering at level 2 and seeds the shared theorem-like counter.
#let (theorem-counter, theorem-box, theorem, _show-theorem) = make-frame(
  "theorem",
  theorion-i18n-map.at("theorem"),
  inherited-levels: 2,
  render: _render-theorem,
)

/// Lemma environment. Shares its counter with `theorem`.
#let (lemma-counter, lemma-box, lemma, _show-lemma) = make-frame(
  "lemma",
  theorion-i18n-map.at("lemma"),
  counter: theorem-counter,
  render: _render-theorem,
)

/// Proposition environment. Shares its counter with `theorem`.
#let (proposition-counter, proposition-box, proposition, _show-proposition) = make-frame(
  "proposition",
  theorion-i18n-map.at("proposition"),
  counter: theorem-counter,
  render: _render-theorem,
)

/// Corollary environment. Shares its counter with `theorem`.
#let (corollary-counter, corollary-box, corollary, _show-corollary) = make-frame(
  "corollary",
  theorion-i18n-map.at("corollary"),
  counter: theorem-counter,
  render: _render-theorem,
)

/// Conjecture environment. Shares its counter with `theorem`.
#let (conjecture-counter, conjecture-box, conjecture, _show-conjecture) = make-frame(
  "conjecture",
  theorion-i18n-map.at("conjecture"),
  counter: theorem-counter,
  render: _render-theorem,
)

// Definition-like environments.

/// Definition environment. Shares its counter with `theorem`.
#let (definition-counter, definition-box, definition, _show-definition) = make-frame(
  "definition",
  theorion-i18n-map.at("definition"),
  counter: theorem-counter,
  render: _render-definition,
)

/// Assumption environment. Shares its counter with `theorem`.
#let (assumption-counter, assumption-box, assumption, _show-assumption) = make-frame(
  "assumption",
  theorion-i18n-map.at("assumption"),
  counter: theorem-counter,
  render: _render-definition,
)

/// Example environment. Shares its counter with `theorem`.
#let (example-counter, example-box, example, _show-example) = make-frame(
  "example",
  theorion-i18n-map.at("example"),
  counter: theorem-counter,
  render: _render-definition,
)

/// Axiom environment. Shares its counter with `theorem`.
#let (axiom-counter, axiom-box, axiom, _show-axiom) = make-frame(
  "axiom",
  theorion-i18n-map.at("axiom"),
  counter: theorem-counter,
  render: _render-definition,
)

// Remark-like environments.

/// Remark environment. Shares its counter with `theorem`.
#let (remark-counter, remark-box, remark, _show-remark) = make-frame(
  "remark",
  theorion-i18n-map.at("remark"),
  counter: theorem-counter,
  render: _render-remark,
)

/// Note environment. Shares its counter with `theorem`.
#let (note-counter, note-box, note, _show-note) = make-frame(
  "note",
  theorion-i18n-map.at("note"),
  counter: theorem-counter,
  render: _render-remark,
)

/// Warning environment. Shares its counter with `theorem`.
#let (warning-counter, warning-box, warning, _show-warning) = make-frame(
  "warning",
  theorion-i18n-map.at("warning"),
  counter: theorem-counter,
  render: _render-remark,
)

/// Proof environment with a localized title. When `of` is provided, it is appended in parentheses (typically a
/// reference to the statement being proved).
///
/// -> content
#let proof(
  /// Optional reference or description of what is being proved.
  /// -> none | str | content
  of: none,
  /// The body of the proof.
  /// -> content
  body,
) = {
  if of == none {
    theorion.proof(title: translate("Proof"), body)
  } else {
    theorion.proof(title: translate("Proof") + [ (#of)], body)
  }
}

/// Applies the show rules of every theorem-like environment defined in this module.
///
/// -> content
#let _theorems-setup(
  /// The content to apply theorem show rules to.
  /// -> content
  body,
) = {
  show: _show-theorem
  show: _show-lemma
  show: _show-proposition
  show: _show-corollary
  show: _show-conjecture
  show: _show-definition
  show: _show-assumption
  show: _show-example
  show: _show-axiom
  show: _show-remark
  show: _show-note
  show: _show-warning

  set-zero-fill(false)
  set-leading-zero(false)
  set-theorion-numbering("1.1")
  set-indent-mode(auto)

  body
}
