# Architecture

How altacv turns a CV dict into a page, and where each kind of code lives. [CONTRIBUTING](CONTRIBUTING.md) covers the workflow and tests.

## The render

`alta()` (`lib.typ`) runs one pipeline. Steps 1 and 2 raise every input error before anything renders.

1. **Options:** `_merge-options` (`data/options.typ`) rewrites deprecated label and preference forms, merges them over `data/defaults.typ` and validates them.
2. **CV:** unknown top-level keys are rejected, `_canonical-cv` rewrites deprecated CV forms, and `_read-sections` (`data/sections.typ`) shape-checks every section.
3. **Document:** the render-time context (`context.typ`), PDF metadata, `set text`, the page with its footer (`sections/footer.typ`), and the paragraph, list and heading rules (`design/styles.typ`).
4. **Content:** the header and intro (`sections/header.typ`, `sections/intro.typ`), then each column section's renderer from `registry.typ`.

## Layers

Paths are under `internal/` unless noted. A module imports only from its own layer, the layers listed, and `@preview` packages. Reviews hold new code to this table.

| Layer | Path | Holds | May import |
|---|---|---|---|
| util | `util/` | generic helpers: presence checks, joins, grouping, checks, date and location formatting; the dict readers (`_field`, `_string-at`) in `fields.typ` | — |
| design | `design/` | the theme, document styles, palettes, icon set | util |
| data | `data/` | reading and checking the CV, labels and preferences; their defaults | util, design |
| context | `context.typ` | render-time `state` set by `alta()` | design |
| primitives | `primitives.typ`, `icons.typ` | text styles, pills, the term row, the divider, `icon()` | util, design, context |
| components | `components/` | layout that takes slots: entry, bibliography, header, footer, … | util, design, context, primitives |
| sections | `sections/` (root) | one renderer per CV part, mapping its data onto components | all of the above |
| root | `registry.typ`, `lib.typ` | renderers bound to section keys; the public API | everything |

The two rules that matter: **components never read the CV** (no `data/`, no `util/fields.typ`: values arrive through slots), so a change to JSON Resume's shape touches only sections; **data never imports UI**, so checking the CV doesn't depend on rendering. `data/` may import `design/` because design is plain values (palettes, the icon set), with no rendering code.

## Sections and components

A section reads fields and fills a component's slots:

```typst
// sections/awards.typ
#let _awards(entries, (labels, prefs, ..)) = _section(
  labels.awards,
  entries.filter(a => _field(a, "title") != none),
  award => _entry(
    title: award.title,
    url: _altacv(award, "url"),
    org: _field(award, "awarder"),
    period: _format-date(_field(award, "date"), prefs, labels),
    summary: _field(award, "summary"),
  ),
)
```

Column sections are registered twice: their spec (field, default column, accepted entries) in `data/sections.typ`, their renderer in `registry.typ`. The header, intro and footer aren't columns; `alta()` calls them directly. A section may also build styled leaf content from primitives to pass as a slot (a reference's attribution line, the header's portrait).

## The look

- **`design/theme.typ`**: plain data, keyed by component: colours, sizes, gaps, weights, separators, and treatments by name (`"emph"`), which `_treat` (`design/styles.typ`) applies. Unitless sizes multiply the body size.
- **`context.typ`**: the accent, body size and rating scale, as `state`, for public helpers (`tag`, `rating`, …) used anywhere in a user's document.

Users style through [preferences](README.md#preferences); the theme itself isn't configurable yet.

## Deprecations

`data/canonical.typ` rewrites each deprecated input into its current form before validation, so nothing downstream sees it. [#239](https://github.com/smur89/alta-typst/issues/239) lists the 2.0.0 removals.
