[private]
default:
    @just --list --unsorted

# Paths
thesis_dir := "thesis"
thesis_entrypoint := thesis_dir + "/main.typ"
thesis_output := thesis_dir + "/main.pdf"

[group("thesis")]
[doc("Compile the thesis with Typst.")]
compile:
    typst compile {{thesis_entrypoint}} --root {{thesis_dir}} {{thesis_output}}

[group("thesis")]
[doc("Watch the thesis source files and recompile on changes.")]
watch:
    typst watch {{thesis_entrypoint}} --root {{thesis_dir}} {{thesis_output}}
