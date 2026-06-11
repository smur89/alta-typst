altacv ${VERSION} — see https://github.com/${GITHUB_REPOSITORY}/releases/tag/${TAG} for the release notes, source tag, and bundled artefacts.

## Package metadata

- **Source repository:** https://github.com/${GITHUB_REPOSITORY}
- **Release:** https://github.com/${GITHUB_REPOSITORY}/releases/tag/${TAG}
- **License:** MIT
- **Category:** `cv`

## Submission checklist

- [x] Package compiles without errors.
- [x] Name follows the [naming rules](https://github.com/typst/packages/blob/main/docs/manifest.md#naming-rules).
- [x] README documents the public API, schema, and configuration, with examples pinned to ${VERSION}.
- [x] Manifest's `license` field matches the contents of `LICENSE`.
- [x] Bundle excludes generated artefacts — only `typst.toml`, `lib.typ`, `icons/`, `LICENSE`, and `README.md` are included.
- [x] Submission opened automatically by alta-typst's release pipeline.
