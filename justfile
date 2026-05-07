set unstable

[private]
default:
    @just --list --unsorted

# Paths.
thesis_entrypoint := "main.typ"
thesis_output := "main.pdf"

[group("thesis")]
[doc("Compile the thesis with Typst.")]
compile *args:
    python scripts/compile.py $TYPST_ROOT/{{thesis_entrypoint}} {{args}}

alias c := compile

[group("thesis")]
[doc("Compile all language and output mode combinations of the thesis with Typst.")]
compile-all:
    python scripts/compile.py --all $TYPST_ROOT/{{thesis_entrypoint}}

alias ca := compile-all

[group("thesis")]
[doc("Watch the thesis source files and recompile on changes.")]
watch *args:
    python scripts/compile.py --watch $TYPST_ROOT/{{thesis_entrypoint}} {{args}}

alias w := watch

[group("style")]
format-typst input_files="$TYPST_ROOT":
    typstyle --verbose --inplace --line-width 120 --indent-width 2 {{input_files}}

alias ft := format-typst
