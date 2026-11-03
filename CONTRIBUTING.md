# Contributing

Thanks for taking the time to look. This project is small enough that almost any thoughtful contribution will be welcomed — but a couple of conventions keep the release pipeline (release-please + Typst Universe) running smoothly.

## Submitting a PR

1. Fork the repository on GitHub.
2. Clone your fork locally and create a branch for your change.
3. Make the changes, commit, and push to your fork.
4. Open a Pull Request against `main` on this repository.

Security issues should be reported privately per [`SECURITY.md`](SECURITY.md) instead of as a PR or issue.

## Project layout

[ARCHITECTURE.md](ARCHITECTURE.md) explains the layers, what each may import, and how a render flows; keep new code to it.

```text
lib.typ           # public entry — re-exports only (`alta()` is in internal/render.typ)
internal/         # wiring (the registry, render-time context) and the shared primitives and icons
internal/util/    # generic helpers: field reads, joins, checks, date formatting
internal/data/    # reading and checking the CV, labels and preferences, and their defaults
internal/design/  # the theme, document-wide styles, palettes and the icon set
internal/components/ # the layout components sections map onto
sections/         # one renderer per part of the CV: the header, then each section
assets/           # in-package raster/SVG resources (e.g. avatar-placeholder)
examples/         # example CVs + shared `_dates.typ` / `_cv.typ` helpers
tests/            # fixtures — CI renders each into examples/tests/*.pdf
tests/components.typ # the component gallery: each component, each variant
tests/panics/     # must-fail fixtures — each names the error it expects
tests/unit/       # `assert` checks of the side-effect-free helpers (dates, fields, header, …)
```

Each `internal/**/*.typ` and `sections/*.typ` opens with a docstring describing its responsibility — `grep -nE '^//' internal/*.typ internal/*/*.typ sections/*.typ` for a quick directory.

Identifiers are kebab-case, matching Typst's standard library (`from-unicode`, `hanging-indent`); JSON Resume and preference keys keep their camelCase (`startDate`). A top-level name that `lib.typ` doesn't re-export starts with `_` (`_page-header`); any module may import it, within the layers in [ARCHITECTURE.md](ARCHITECTURE.md). Only what `lib.typ` re-exports is part of the public API (`alta`, `alta-from-json`, `from-json-resume`, `avatar-placeholder`, `palettes`, `maps-providers`, `icon`, `name`, `term`, `tag`, `divider`, `rating`, `styled-link`). `lib.typ` imports nothing but what it re-exports: Typst re-exports every name a module imports, so anything else would leak into a user's `#import "@preview/altacv:…": *` (`tests/unit/api.typ` pins the exported names). Internal code calls the merged preferences `prefs`; `preferences` is the caller-facing parameter. Cross-file imports use relative paths (`#import "../internal/context.typ": ...` from `sections/`).

## Development loop

Install Typst at the version CI uses — see `TYPST_VERSION` in `.github/workflows/build.yml`. Two fonts must also be available on the system font path: **Lato** (the default body font, override via `preferences.font`) and the desktop **FontAwesome** set (read by [`@preview/fontawesome`](https://typst.app/universe/package/fontawesome) for icons — without it, icons render as tofu).

On macOS, one block sets up everything Homebrew can provide:

```bash
brew install typst
brew install --cask font-lato font-fontawesome
```

Linux / Windows / manual install paths: see the [Fonts section in the README](README.md#fonts). Run `typst fonts` to confirm both are visible to Typst.

Most everyday tasks go through the `Makefile`; `make help` lists every target. The ones you'll use most:

```sh
make check        # test + fmt-check
make fmt          # format every tracked .typ in place (typstyle)
make docker-pdfs  # regenerate the committed renders in the pinned image (see below)
```

`make check` is the local equivalent of the CI lint + `typstyle` jobs — green here means both will pass too.

### Helper unit tests

Helpers that only compute a value are checked with `assert.eq` under `tests/unit/`, one file per module; `make test-unit` (part of `make test`) runs them. That's quicker and more precise than a PDF fixture. For helpers that return content, `tests/unit/_plain.typ` flattens it to text.

### Error-path tests

Every panic a user can hit has a fixture under `tests/panics/` whose first line is `// expect: <part of the message>`. `make test-panics` (part of `make test`) compiles each one and fails if it compiles, or fails without that text. Adding a validator? Add a fixture for it.

### Formatting

Typst sources are formatted with [typstyle](https://github.com/Enter-tainer/typstyle). CI runs `make fmt-check` and fails on any unformatted file, so run `make fmt` before committing (or wire it into your editor). Pin the same version CI uses — `TYPSTYLE_VERSION` in [`.github/workflows/build.yml`](.github/workflows/build.yml) — since formatter output can shift between releases; `brew install typstyle` on macOS. Formatting is purely mechanical and never changes rendered output.

### Regenerating PDF fixtures (Docker)

CI byte-compares the committed `examples/tests/*.pdf` against a fresh render every PR (`make -B test-pdfs` then `make check-drift DRIFT_PATHS='examples/tests/*.pdf'`). Local renders on macOS, or against a non-pinned Lato/FontAwesome install, drift from the CI bytes — so any change that touches rendering (icon glyphs, `lib.typ`, anything under `internal/` or `sections/`, the FA version) needs the fixtures regenerated inside the pinned CI image:

```sh
make docker-pdfs   # pulls the pinned ghcr.io/smur89/alta-typst-ci image and runs `make -B all` (full rebuild)
make docker-shell  # drop into the image with the workspace mounted, for ad-hoc work
```

`--platform linux/amd64` is forced so the output is byte-identical regardless of host architecture (Apple Silicon falls back to emulation — slower but reproducible). The image is published by [`.github/workflows/image.yml`](.github/workflows/image.yml); the pinned tag lives in the `Makefile` (`DOCKER_IMAGE`). `build.yml`'s `TYPST_VERSION` and `FA_VERSION` must match it: CI's lint job re-renders the fixtures on its runner and compares them byte for byte.

If you'd rather drive Typst directly, the manual incantations are:

```sh
typst compile --root . examples/example_full.typ examples/example_full.pdf
for f in tests/*.typ; do typst compile --root . --format pdf "$f" /dev/null; done
```

`--format pdf` is required when the output path is `/dev/null` — Typst cannot infer the format from a path with no extension.

CI runs the same compile sweep on every PR and uploads `cv-pdf` and `example-full-pdf` artifacts, so reviewers can see your output without checking out locally.

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

This is the most common shape of contribution. Two changes:

1. Add a row to `_network-icons` in `internal/design/icon-set.typ`. Use the lowercase key (`_profile-network` in `internal/data/cv.typ` lowercases the network before the lookup) and map it to the canonical FontAwesome glyph name — browse [fontawesome.com/search](https://fontawesome.com/search) to find the right one (e.g. `"linkedin"`, `"x-twitter"`, `"github"`). `@preview/fontawesome` handles the brand-vs-solid font selection automatically.
2. Add the canonical capitalised name to the supported-networks list in `README.md` (under "Profile networks").

`feat:` commit. The icon will render automatically wherever a `basics.profiles` entry uses the new network. If the new icon is a utility / Free Solid glyph rather than a brand mark (e.g. a generic globe-style fallback), also add the lowercase key to `_solid-names` in `internal/design/icon-set.typ` so `fa-icon` is called with `solid: true`.

## Adding a section, preference, or label

For a **new section**: add the renderer under `sections/<name>.typ`, add its spec to `_section-specs` in `internal/data/sections.typ` (column; `read` / `items` when it isn't a plain entry array; `fields`, a type rule per field its renderer draws; `keep`, when some entries shouldn't render; `check`, for checks that need more than a type, in `internal/data/cv-checks.typ`) and its renderer to `_renderers` in `internal/registry.typ` (every renderer takes `(entries, ctx)`, where `entries` are the checked entries `keep` let through and `ctx` is `(labels, prefs, format-date, owner)`, usually destructured as `(labels, format-date, ..)`), and add the heading to `internal/data/labels-en.toml`. For a **new preference**: add it to `_default-preferences` in `internal/data/defaults.typ`, give it a rule in `_preference-rules` (`internal/data/validation.typ`; `tests/unit/validation.typ` fails until you do) with a `tests/panics/` fixture, and read it from `ctx.prefs`. Deprecating an input shape? Rewrite it into the current one in `internal/data/canonical.typ` rather than in a renderer. A new component, or a new variant of one, gets an entry in the component gallery (`tests/components.typ`). Any change to the data shape or the rendered surface should also add a fixture under `tests/` exercising it — `tests/publication_types.typ` is a small self-contained example.

The `tests/` suite doubles as a regression guard: `make test-pdfs` regenerates `examples/tests/*.pdf` from each fixture, and CI fails the lint job if the rendered output drifts from the committed PDF. After making a change that intentionally affects output, run `make docker-pdfs` (see [Regenerating PDF fixtures](#regenerating-pdf-fixtures-docker)) and commit the updated PDFs alongside your source change.

## Security

See [`SECURITY.md`](SECURITY.md) for how to report a vulnerability.
