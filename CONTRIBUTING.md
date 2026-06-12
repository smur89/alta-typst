# Contributing

Thanks for taking the time to look. This project is small enough that almost any thoughtful contribution will be welcomed — but a couple of conventions keep the release pipeline (release-please + Typst Universe) running smoothly.

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
2. Register the key in `_icon_sources` in `lib.typ`. Use the lowercase form; the lookup `lower(profile.network)` normalises the caller's spelling.
3. Add the canonical capitalised name to the supported-networks list in `README.md` (under "Profile networks").

`feat:` commit. The icon will render automatically wherever a `basics.profiles` entry uses the new network.

## Adding a section, preference, or label

Any change to the data shape or the rendered surface should also add a fixture under `tests/` exercising it. Look at `tests/publication_types.typ` for a small self-contained example.

## Security

See [`SECURITY.md`](SECURITY.md) for how to report a vulnerability.
