# Architecture

How altacv turns a CV dict into a page, and where each kind of code lives. [CONTRIBUTING](CONTRIBUTING.md) covers the workflow and tests.

## The render

`alta()` (`render.typ`, re-exported from `lib.typ`) runs one pipeline. Steps 1 and 2 raise every input error before anything renders; only the public helpers (`rating`, …) still check their own arguments, as users call them directly.

1. **Options:** `_merge-options` (`data/options.typ`) rewrites deprecated label and preference forms, merges them over `data/defaults.typ` and validates them.
2. **CV:** `_read-cv` (`data/read.typ`) rejects unknown top-level keys, has `_canonical-cv` drop `none` fields and rewrite deprecated CV forms, checks `basics` and `objective`, and has `_read-sections` (`data/sections.typ`) shape-check every section, check each entry's field types against its spec's `fields`, keep the entries its spec's `keep` says render, and run its `check` on those.
3. **Document:** `_pdf-metadata` (`data/metadata.typ`), then `_document` (`document.typ`): the render-time context (`context.typ`), `set text`, the page with its footer (`sections/footer.typ`), and the paragraph, list and heading rules (`design/styles.typ`).
4. **Content:** the header and intro (`sections/header.typ`, `sections/intro.typ`), then each column section's renderer from `registry.typ`, laid out by `_columns` (`components/columns.typ`).

## Layers

Paths are under `internal/` unless noted. A module imports only from its own layer, the layers listed, and `@preview` packages. Reviews hold new code to this table.

| Layer | Path | Holds | May import |
|---|---|---|---|
| util | `util/` | generic helpers: presence checks, joins, grouping, checks, date formatting; the dict readers (`_field`, `_string-at`) in `fields.typ` | — |
| design | `design/` | the theme, document styles, palettes, icon set | util |
| data | `data/` | reading and checking the CV, labels and preferences; their defaults; the readers that know JSON Resume's shape (`_format-location`, `_entry-period` in `cv.typ`) | util, design |
| context | `context.typ` | render-time `state` set by `alta()` | design |
| document | `document.typ` | the document setup shared by `alta()` and the component gallery | design, context |
| primitives | `primitives.typ`, `icons.typ` | text styles, pills, the term row, the divider, `icon()` | util, design, context |
| components | `components/` | layout that takes slots: entry, bibliography, header, footer, … | util, design, context, primitives |
| sections | `sections/` (root) | one renderer per CV part, mapping its data onto components | all of the above |
| root | `registry.typ`, `render.typ`; `lib.typ` (repository root) | renderers bound to section keys; the render pipeline; the public API, as re-exports only | everything |

The two rules that matter: **components never read the CV** (no `data/`, no `util/fields.typ`: values arrive through slots), so a change to JSON Resume's shape touches only sections and `data/`; **data never imports UI**, so checking the CV doesn't depend on rendering. `data/` may import `design/` because design is plain values (palettes, the icon set), with no rendering code.

Parts a user can restyle with a show rule (the README's Restyling parts) are labelled through `_part` (`design/styles.typ`), on the raw value where it last appears unstyled, with any styling (`upper()`, a treatment) applied around it. That puts each label in the layer that renders its part: a heading's in its show rule (`design/styles.typ`), the footer's where `_document` sets the page.

## Sections and components

A section reads fields and fills a component's slots:

```typst
// sections/awards.typ
#let _awards(entries, (labels, format-date, ..)) = _section(
  labels.awards,
  entries.filter(a => _field(a, "title") != none),
  award => _entry(
    title: award.title,
    url: _altacv(award, "url"),
    org: _field(award, "awarder"),
    period: format-date(_field(award, "date")),
    summary: _field(award, "summary"),
  ),
)
```

Renderers take their entries and `ctx`: the labels, the preferences, `format-date` (bound to `dateFormat` and `labels.months`), the CV `owner` and `owners` (every spelling of the owner's name, normalised). A section doesn't check or filter its input: step 2 checked every field it draws and dropped the entries that don't render, so it only maps values onto slots. A few fields are read leniently instead, by design; the `_section-specs` comment lists them. Column sections are registered twice: their spec (field, default column, accepted entries, field types, which entries render, other checks) in `data/sections.typ`, their renderer in `registry.typ`. The header, intro and footer aren't columns; `alta()` calls them directly, with the same `(cv, ctx)`. A section may also build styled leaf content from primitives to pass as a slot (a reference's attribution line, the header's portrait).

## The look

- **`design/theme.typ`**: plain data. `_tokens` are the scales: Material 3 type roles (`display` … `body`), Bootstrap colour roles (`body`, `secondary`, `emphasis`, `border`), CSS size keywords for `space`, plus weights, stroke widths and leading. `_build-theme` maps them onto component roles. Sizes multiply the body size; `_treat` (`design/styles.typ`) applies the named treatments.
- **`context.typ`**: the accent, body size and rating scale, as `state`, for public helpers (`tag`, `rating`, …) used anywhere in a user's document.

Users style through [preferences](README.md#preferences); the theme isn't configurable yet. When it is, `alta()` deep-merges token overrides, rebuilds, then merges role overrides.

## Deprecations

`data/canonical.typ` rewrites each deprecated input into its current form before validation, so nothing downstream sees it. [#239](https://github.com/smur89/alta-typst/issues/239) lists the 2.0.0 removals.
