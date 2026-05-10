#!/usr/bin/env python
import argparse
import itertools
import os
import subprocess
import sys
import time
from enum import Enum
from pathlib import Path


class CompileResult(Enum):
    SUCCESS = "success"
    ERROR = "error"


LANGS = ("en", "es", "ca")
OUTPUTS = ("digital", "print")
DEFAULT_LANG = "en"
DEFAULT_OUTPUT = "digital"


def output_path(input_file: Path, lang: str, output: str) -> Path:
    return input_file.with_name(f"{input_file.stem}-{lang}-{output}.pdf")


def typst_command(
    *,
    watch: bool,
    input_file: Path,
    output_file: Path,
    lang: str,
    output: str,
) -> list[str]:
    subcommand = "watch" if watch else "compile"
    return [
        "typst",
        subcommand,
        "--input",
        f"lang={lang}",
        "--input",
        f"output={output}",
        str(input_file),
        str(output_file),
    ]


def run_typst(
    *,
    watch: bool,
    input_file: Path,
    lang: str,
    output: str,
) -> CompileResult:
    out_file = output_path(input_file, lang, output)
    cmd = typst_command(
        watch=watch,
        input_file=input_file,
        output_file=out_file,
        lang=lang,
        output=output,
    )

    env = os.environ.copy()
    # Set SOURCE_DATE_EPOCH so Typst produces reproducible output for this invocation.
    env["SOURCE_DATE_EPOCH"] = str(int(time.time()))

    action = "Watching" if watch else "Compiling"
    print(f"==> {action} {input_file} (lang={lang}, output={output}) -> {out_file}")

    if watch:
        process = subprocess.run(cmd, env=env)
    else:
        process = subprocess.run(cmd, env=env, capture_output=True, text=True)
        if process.stdout:
            print(process.stdout, end="")
        if process.stderr:
            print(process.stderr, file=sys.stderr, end="")

    if process.returncode != 0:
        print(
            f"Failed: {input_file} (lang={lang}, output={output})",
            file=sys.stderr,
        )
        return CompileResult.ERROR

    return CompileResult.SUCCESS


def compile_all(input_file: Path) -> int:
    combinations = list(itertools.product(LANGS, OUTPUTS))
    print(f"==> Compiling {len(combinations)} variant(s) of {input_file}.")

    succeeded: list[tuple[str, str]] = []
    failed: list[tuple[str, str]] = []

    for lang, output in combinations:
        result = run_typst(
            watch=False,
            input_file=input_file,
            lang=lang,
            output=output,
        )
        if result == CompileResult.SUCCESS:
            succeeded.append((lang, output))
        else:
            failed.append((lang, output))

    if succeeded:
        print(f"\nCompiled {len(succeeded)} variant(s):")
        for lang, output in succeeded:
            print(f"  - {output_path(input_file, lang, output)}")

    if failed:
        print(f"\nFailed {len(failed)} variant(s):", file=sys.stderr)
        for lang, output in failed:
            print(f"  - lang={lang}, output={output}", file=sys.stderr)

    return 1 if failed else 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Compile (or watch) a Typst document for a given language and output mode.",
    )
    parser.add_argument(
        "file",
        type=Path,
        help="Path to the Typst entrypoint file.",
    )
    parser.add_argument(
        "--watch",
        action="store_true",
        help="Watch sources and recompile on changes.",
    )
    parser.add_argument(
        "--lang",
        choices=LANGS,
        default=DEFAULT_LANG,
        help=f"Language code (default: {DEFAULT_LANG}).",
    )
    parser.add_argument(
        "--output",
        choices=OUTPUTS,
        default=DEFAULT_OUTPUT,
        help=f"Output mode (default: {DEFAULT_OUTPUT}).",
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="Compile all combinations of language and output mode.",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    if args.all and args.watch:
        print("Error: --all cannot be combined with --watch.", file=sys.stderr)
        sys.exit(2)

    if args.all:
        sys.exit(compile_all(args.file))

    result = run_typst(
        watch=args.watch,
        input_file=args.file,
        lang=args.lang,
        output=args.output,
    )
    sys.exit(0 if result == CompileResult.SUCCESS else 1)


if __name__ == "__main__":
    main()
