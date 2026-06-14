# Contributing

Thanks for taking the time to look. This project is small enough that almost any thoughtful contribution will be welcomed — but a couple of conventions keep the release pipeline (release-please + Typst Universe) running smoothly.

## Project layout

```text
lib.typ           # public entry — re-exports + `alta()`
internal/         # shared infrastructure, one concern per file
sections/         # one renderer per dispatched CV section
icons/            # vendored Font Awesome SVGs
examples/         # example CVs + shared `_dates.typ` helper
tests/            # fixtures — CI renders each into examples/tests/*.pdf
```

Each `internal/*.typ` and `sections/*.typ` opens with a docstring describing its responsibility — `grep -nE '^//' internal/*.typ` for a quick directory.

Modules under `internal/` are leading-underscore private; only what `lib.typ` re-exports is part of the public API (`alta`, `palettes`, `maps-providers`, `icon`, `name`, `term`, `tag`, `divider`, `rating`, `styled-link`). Cross-file imports use relative paths (`#import "../internal/state.typ": ...` from `sections/`).

## Development loop

Install Typst at the version CI uses — see `TYPST_VERSION` in `.github/workflows/build.yml`. The `Lato` font must be installed for the example to render correctly.

Most everyday tasks go through the `Makefile`:

```sh
make            # build every example PDF + the README preview image
make example    # build examples/example.pdf + examples/preview.png
make test       # compile every example + fixture (same shape as CI lint)
make clean      # remove generated PDFs and PNGs
make help       # list every target
```

`make test` is the local equivalent of the CI lint job — green here means CI lint will pass too. `make` (default) regenerates `examples/preview.png` at 150 DPI; pass `PPI=300` for a higher-resolution render.

If you'd rather drive Typst directly, the manual incantations are:

```sh
typst compile --root . examples/example.typ examples/example.pdf
for f in tests/*.typ; do typst compile --root . --format pdf "$f" /dev/null; done
```

`--format pdf` is required when the output path is `/dev/null` — Typst cannot infer the format from a path with no extension.

CI runs the same compile sweep on every PR and uploads `example-pdf` and `preview-png` artifacts, so reviewers can see your output without checking out locally.

## Conventional commits

The repo uses [release-please](https://github.com/googleapis/release-please) to cut releases. Versioning is derived from commit messages on `main`, so each merged PR needs a clean conventional-commit message.

| Prefix | Bump | Use for |
|---|---|---|
| `fix:` | patch | Bug fix, doc correction, broken link, cosmetic polish |
| `feat:` | minor | New section, new `preferences` or `labels` key, new profile network |
| `feat!:` or `BREAKING CHANGE:` footer | major | API change that existing users would need to migrate |
| `chore:`, `docs:`, `ci:`, `refactor:`, `test:` | none | Internal changes that shouldn't trigger a release |

PRs squash-merge with the PR title as the commit subject, so just make the **PR title** a conventional commit. The body of the squash commit comes from the PR description.

## Adding a profile-network icon

This is the most common shape of contribution. Three changes:

1. Vendor a single-path SVG into `icons/<name>.svg`. The `fill="#666666"` attribute must be baked into the path — see `icons/github.svg` for the exact format. [Font Awesome Free](https://fontawesome.com/) (CC BY 4.0) is the existing source.
2. Register the key in `_network_icon_sources` in `internal/icons.typ`. Use the lowercase form; the lookup `lower(profile.network)` normalises the caller's spelling.
3. Add the canonical capitalised name to the supported-networks list in `README.md` (under "Profile networks").

`feat:` commit. The icon will render automatically wherever a `basics.profiles` entry uses the new network.

## Adding a section, preference, or label

For a **new section**: add the renderer under `sections/<name>.typ`, register it in `_sections` in `internal/layout.typ` (column + dispatch closure), and add the heading to `_default_labels` in `internal/defaults.typ`. For a **new preference**: add it to `_default_preferences` in `internal/layout.typ`, validate it inside `alta()` in `lib.typ`, and thread it through to the consumer. Any change to the data shape or the rendered surface should also add a fixture under `tests/` exercising it — `tests/publication_types.typ` is a small self-contained example.

The `tests/` suite doubles as a regression guard: `make test-pdfs` regenerates `examples/tests/*.pdf` from each fixture, and CI fails the lint job if the rendered output drifts from the committed PDF. After making a change that intentionally affects output, run `make test-pdfs` locally and commit the updated PDFs alongside your source change.

## Security

See [`SECURITY.md`](SECURITY.md) for how to report a vulnerability.
