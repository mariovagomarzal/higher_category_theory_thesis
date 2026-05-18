# Thesis: A Formalization of Higher-Order Categories in Lean 4

This repository contains the source code for my thesis document. The Lean 4 code
of the formalization is tracked as a Git submodule under `thesis/formalization`
and lives in [this repository][formalization-repo].

## Cloning

Clone the repository with its submodules in one step:

```bash
git clone --recurse-submodules https://github.com/mariovagomarzal/thesis
```

If you already cloned the repository without `--recurse-submodules`, run
`just env` from inside the `devenv shell` to fetch and sync the submodule.

## Development environment

The development environment is set up using Nix and [Devenv][devenv]. Run the
following command to enter the development environment:

```bash
devenv shell
```

Run `just` to see the available commands or check the `justfile` for more
details.

## Conventions

This project follows the [Conventional Commits][conventional-commits]
specification for commit messages. There are no strict rules for branching in
this repository.

## Authors

- [Mario Vago Marzal][mario]

Supervided by:

- [Enric Cosme Llópez][enric]
- [Raúl Ruiz Mora][raul]

## License

Copyright (c) 2026 Mario Vago Marzal. All rights reserved.

This project is licensed under the Apache License 2.0. See the
[LICENSE](LICENSE) file for details.

<!-- External links -->

[formalization-repo]: https://github.com/mariovagomarzal/higher_category_theory
[devenv]: https://devenv.sh
[conventional-commits]: https://www.conventionalcommits.org/en/v1.0.0/
[mario]: https://github.com/mariovagomarzal
[enric]: https://github.com/encosllo
[raul]: https://github.com/ruizmoraraul
