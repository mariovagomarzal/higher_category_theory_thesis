[private]
default:
    @just --list --unsorted

# Paths.
thesis_entrypoint := "main.typ"
thesis_output := "main.pdf"

# Sets SOURCE_DATE_EPOCH so Typst produces reproducible output for the current invocation.
source_date_epoch := "SOURCE_DATE_EPOCH=$(date +%s)"

[group("thesis")]
[doc("Compile the thesis with Typst.")]
compile:
    {{source_date_epoch}} typst compile $TYPST_ROOT/{{thesis_entrypoint}}

[group("thesis")]
[doc("Watch the thesis source files and recompile on changes.")]
watch:
    {{source_date_epoch}} typst watch $TYPST_ROOT/{{thesis_entrypoint}}

[group("style")]
format-typst INPUT_FILES="$TYPST_ROOT":
    typstyle --verbose --inplace --line-width 120 --indent-width 2 {{INPUT_FILES}}

alias ft := format-typst
