# Contributing

Thanks for taking the time to look. This project is small enough that almost any thoughtful contribution will be welcomed — but a couple of conventions keep the release pipeline (release-please + Typst Universe) running smoothly.

## Development loop

Install Typst at the version CI uses (currently `0.14.2` — see `TYPST_VERSION` in `.github/workflows/build.yml`). The `Lato` font must be installed for the example to render correctly.

Compile the example and the fixtures locally:

```sh
typst compile --root . examples/example.typ examples/example.pdf
for f in tests/*.typ; do typst compile --root . "$f" /dev/null; done
```

If your change is visual, also regenerate the preview to eyeball it:

```sh
typst compile --root . --format png --ppi 150 examples/example.typ 'examples/preview-{p}.png'
```

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
