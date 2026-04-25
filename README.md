# Thesis: A Formalization of Higher-Order Categories in Lean 4

This repository contains the source code for my thesis document. The Lean 4 code
of the formalization can be found in [this repository][formalization-repo].

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
