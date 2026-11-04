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
| util | `util/` | generic helpers: presence checks, joins, grouping, a deep merge, checks, date formatting; the dict readers (`_field`, `_string-at`) in `fields.typ` | — |
| design | `design/` | the theme, document styles, the built-in themes and palettes, icon set | util |
| data | `data/` | reading and checking the CV, labels and preferences; their defaults; the readers that know JSON Resume's shape (`_format-location`, `_entry-period` in `cv.typ`) | util, design |
| context | `context.typ` | render-time `state` set by `alta()` | design |
| document | `document.typ` | the document setup shared by `alta()` and the component gallery | design, context |
| primitives | `primitives.typ`, `icons.typ` | text styles, pills, the term row, the divider, `icon()` | util, design, context |
| components | `components/` | layout that takes slots: entry, bibliography, header, footer, … | util, design, context, primitives |
| sections | `sections/` (root) | one renderer per CV part, mapping its data onto components | all of the above |
| root | `registry.typ`, `render.typ`; `lib.typ` (repository root) | renderers bound to section keys; the render pipeline; the public API, as re-exports only | everything |

The two rules that matter: **components never read the CV** (no `data/`, no `util/fields.typ`: values arrive through slots), so a change to JSON Resume's shape touches only sections and `data/`; **data never imports UI**, so checking the CV doesn't depend on rendering. `data/` may import `design/` because design is plain values (themes, palettes, the icon set), with no rendering code.

Parts a user can restyle with a show rule (the README's Restyling parts) are labelled through `_part` (`design/styles.typ`), on the raw value where it last appears unstyled, with any styling (`upper()`, a treatment) applied around it. That puts each label in the layer that renders its part: a heading's in its show rule (`design/styles.typ`), the footer's where `_document` sets the page. Labels the template only uses for its own rules are prefixed `alta-internal-`; every other `alta-` label is public API, listed in the README.

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

- **`design/theme.typ`**: plain data. `_tokens` are the scales and their defaults: Material 3 type roles (`display` … `body`), the colour roles (the default theme's), separators and treatments, CSS size keywords for `space`, plus weights, stroke widths and leading. `_build-theme` maps them onto component roles, deriving `secondary` and `border` from `body`. `_theme-for` builds the theme to render with, once per render in `_document`: the chosen theme's tokens, then `preferences.colours`, deep-merged over `_tokens`. Every component reads it from state in `context`. Helpers that return `none` for an empty line (`_fact-line`, `_preamble`) decide that from their parts first, outside `context`, and read the theme only to format what's there. Sizes multiply the body size; `_treat` (`design/styles.typ`) applies the named treatments.
- **`design/presets.typ`**: the built-in `themes` and the deprecated accent `palettes`. Each theme is a set of `_tokens` overrides, `(colours: ...)` with every colour role; validation lets a theme set only the colours for now, every role of them.
- **`context.typ`**: the built theme, body size and rating scale, as `state`. Components and the public helpers (`tag`, `rating`, …), which may sit anywhere in a user's document, read the theme from it in `context`; `_content-styles` takes it from `_document` directly.

Users style through [preferences](README.md#preferences) and show rules, in that order of precedence: `theme` picks a theme (`themes.teal` unless set), `colours` overrides its roles, and a show rule on a labelled part overrides both. A theme sets only colours so far; as `_tokens` overrides, it can set the type, spacing and strokes too once its validation allows them.

## Deprecations

`data/canonical.typ` rewrites each deprecated input into its current form before validation, so nothing downstream sees it. [#239](https://github.com/smur89/alta-typst/issues/239) lists the 2.0.0 removals.
