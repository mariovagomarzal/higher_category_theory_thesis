set unstable

[private]
default:
    @just --list --unsorted

# Paths.
thesis_entrypoint := "main.typ"
thesis_output := "main.pdf"

# Sets SOURCE_DATE_EPOCH so Typst produces reproducible output for the current invocation.
source_date_epoch := "SOURCE_DATE_EPOCH=$(date +%s)"

# Typst custom input arguments.
default_lang := "en"
default_output := "digital"
input_arg(arg_name, arg_value) := "--input " + arg_name + "=" + arg_value

[group("thesis")]
[doc("Compile the thesis with Typst.")]
compile lang=default_lang output=default_output:
    {{source_date_epoch}} typst compile {{input_arg("lang", lang)}} {{input_arg("output", output)}} \
        $TYPST_ROOT/{{thesis_entrypoint}}

[group("thesis")]
[doc("Watch the thesis source files and recompile on changes.")]
watch lang=default_lang output=default_output:
    {{source_date_epoch}} typst watch {{input_arg("lang", lang)}} {{input_arg("output", output)}} \
        $TYPST_ROOT/{{thesis_entrypoint}}

[group("style")]
format-typst input_files="$TYPST_ROOT":
    typstyle --verbose --inplace --line-width 120 --indent-width 2 {{input_files}}

alias ft := format-typst
