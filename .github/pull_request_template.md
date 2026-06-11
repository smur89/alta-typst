## Summary

<!-- One or two sentences: what does this change and why? Link the issue if any. -->

## Rendered output

<!-- This is a visual template — please attach a screenshot of the rendered PDF (or a diff vs. main) for any change that affects layout, spacing, colour, or icons. CI uploads an `example-pdf` artifact for every run; you can grab the rendered example from there. -->

## Test plan

<!-- Tick whichever apply, and add any new ones. -->

- [ ] `typst compile --root . examples/example.typ examples/example.pdf` succeeds
- [ ] Each `tests/*.typ` fixture compiles
- [ ] Added or updated a fixture under `tests/` if this PR touches rendering logic
- [ ] Updated the README if this PR changes a public API, data-schema key, or supported profile network

## Notes for the reviewer

<!-- Anything non-obvious: trade-offs, deferred work, follow-up issues, etc. -->
