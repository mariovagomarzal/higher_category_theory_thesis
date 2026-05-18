set unstable

[private]
default:
    @just --list --unsorted

[group("env")]
[doc("Initialize and sync Git submodules (e.g. the Lean 4 formalization).")]
env:
    git submodule update --init --recursive

# Paths.
thesis_entrypoint := "main.typ"
thesis_output := "main.pdf"
website_dir := "website"
pdfs_dir := website_dir / "public" / "pdfs"

[group("thesis")]
[doc("Compile the thesis with Typst.")]
compile *args:
    python scripts/compile.py $TYPST_ROOT/{{thesis_entrypoint}} {{args}}

alias c := compile

[group("thesis")]
[doc("Compile all language, output mode and cover combinations of the thesis with Typst.")]
compile-all:
    python scripts/compile.py --all $TYPST_ROOT/{{thesis_entrypoint}}

alias ca := compile-all

[group("thesis")]
[doc("Watch the thesis source files and recompile on changes.")]
watch *args:
    python scripts/compile.py --watch $TYPST_ROOT/{{thesis_entrypoint}} {{args}}

alias w := watch

[private]
[group("website")]
[doc("Copy compiled thesis PDFs into the website public folder.")]
assets: compile-all
    mkdir -p {{pdfs_dir}}
    cp $TYPST_ROOT/main-*-*-*.pdf {{pdfs_dir}}/

[group("website")]
[working-directory("website")]
[doc("Run the Astro dev server.")]
dev: assets
    pnpm dev

[group("website")]
[working-directory("website")]
[doc("Build the Astro site.")]
build: assets
    pnpm build

[group("website")]
[working-directory("website")]
[doc("Preview the built Astro site.")]
preview: assets
    pnpm preview

[group("style")]
format-typst input_files="$TYPST_ROOT":
    typstyle --verbose --inplace --line-width 120 --indent-width 2 {{input_files}}

alias ft := format-typst
