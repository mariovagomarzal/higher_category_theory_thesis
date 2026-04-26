[private]
default:
    @just --list --unsorted

# Paths.
thesis_entrypoint := "main.typ"
thesis_output := "main.pdf"

[group("thesis")]
[doc("Compile the thesis with Typst.")]
compile:
    typst compile $TYPST_ROOT/{{thesis_entrypoint}}

[group("thesis")]
[doc("Watch the thesis source files and recompile on changes.")]
watch:
    typst watch $TYPST_ROOT/{{thesis_entrypoint}}

[group("style")]
format-typst INPUT_FILES="$TYPST_ROOT":
    typstyle --verbose --inplace --line-width 120 --indent-width 2 {{INPUT_FILES}}

alias ft := format-typst
