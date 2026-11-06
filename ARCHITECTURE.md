# Architecture

How altacv turns a CV dict into a page, and where each kind of code lives. [CONTRIBUTING](CONTRIBUTING.md) covers the workflow and tests.

## The render

`alta()` (`render.typ`, re-exported from `lib.typ`) runs one pipeline. Steps 1 and 2 raise every input error before anything renders; only the public helpers (`rating`, …) still check their own arguments, as users call them directly.

1. **Options:** `_merge-options` (`data/options.typ`) rewrites deprecated label and preference forms, merges them over `data/defaults.typ` and validates them. The labels start from the document language's bundled translation (`text.lang` where `alta()` is called, so `alta()` renders in `context`), over the English.
2. **CV:** `_read-cv` (`data/read.typ`) rejects unknown top-level keys, has `_canonical-cv` drop `none` fields and rewrite deprecated CV forms, checks `basics` and `objective`, and has `_read-sections` (`data/sections.typ`) shape-check every section, check each entry's field types against its spec's `fields`, keep the entries its spec's `keep` says render, and run its `check` on those.
3. **Document:** `altacv` (`render.typ`) checks its theme and applies `_document` (`document.typ`): theme state, `set text`, the margins, and the paragraph and list rules (`_base-styles`, `design/styles.typ`), then the template's heading rules (`_level-headings`): the name is the `title` element, sections level 1, groups level 2, an entry one level below its section or group. Components emit headings by depth (`components/frame.typ`), so the same CV takes either form's levels; the markup blocks (`blocks.typ`) do too, an `entry` one level below the heading before it. `alta()` returns both of its forms, each labelled: the standalone render (`<alta-internal-standalone>`) and a `metadata` of its arguments (`<alta-internal-cv>`). `altacv`'s show rules pick one through the style chain, so the choice holds on the first layout pass and ends with the template's scope: they hide the standalone render and show the metadata as `_alta-content`, which emits only content: the `<alta-cv>` marker the footer helpers (`footers.typ`) read, then the CV drawn by the JSON Resume mapping (`_resume`, behind the public `resume`, in `adapter/json-resume.typ` at the repository root) from the public blocks, given the checked, canonical CV in camelCase (`_read-cv`'s `json-resume`) and the merged labels, so they aren't merged twice, and preferences. `_read-cv` makes a bare-string `basics.image` a `path` from `internal/` (`_image-path`), so both forms resolve it where it always has. `set document` fails inside a container, where `alta()` may sit, so `_alta-content` leaves the PDF metadata from `_pdf-metadata` (`data/metadata.typ`) in a marker that `altacv` sets at the top level.

   Without the template the metadata renders nothing and the standalone render shows: `_alta-standalone` sets the PDF metadata and applies `_standalone` (`document.typ`), with the set-rule preferences, the footer and its own heading rules (`_label-headings`: today's levels, set by `heading(offset: 1)`, the name the one level-1 heading, matched by internal label), around step 4's content (removed in the next major, [#239](https://github.com/smur89/alta-typst/issues/239), when `alta()` returns `_alta-content` directly).
4. **Content** (standalone): the header and intro (`sections/header.typ`, `sections/intro.typ`), then each column section's renderer from `registry.typ`, laid out by `_columns` (`components/columns.typ`).

## Layers

Paths are under `internal/` unless noted. A module imports only from its own layer, the layers listed, and `@preview` packages. Reviews hold new code to this table.

| Layer | Path | Holds | May import |
|---|---|---|---|
| util | `util/` | generic helpers: presence checks, joins, grouping, a deep merge, checks, date formatting; the dict readers (`_field`, `_string-at`) in `fields.typ` | — |
| design | `design/` | the theme, document styles, the built-in themes and palettes, icon set | util |
| data | `data/` | reading and checking the CV, labels and preferences; their defaults; the contact bar's entries from `basics` (`contacts.typ`); the readers that know JSON Resume's shape (`_location-parts`, `_entry-period`, a publication's `_authors` and its identifiers (`_identifiers`, `_identifier-refs`, `_identifier-url`), a skill's `_skill-rating`, in `cv.typ`), shared by the sections and the markup blocks | util, design |
| context | `context.typ` | render-time `state` set by `alta()` and `altacv` | design |
| document | `document.typ` | the document setup shared by `altacv`, standalone `alta()` and the component gallery | design, context |
| primitives | `primitives.typ`, `icons.typ` | text styles, pills, the term row, the divider, `icon()` | util, design, context |
| components | `components/` | layout that takes slots: entry, bibliography, header, footer, … | util, design, context, primitives |
| sections | `sections/` (root) | one renderer per CV part, and the page footer, each mapping its data onto components; standalone `alta()`'s only, until the next major ([#239](https://github.com/smur89/alta-typst/issues/239)) removes it | all of the above |
| root | `registry.typ`, `render.typ`, `footers.typ`, `blocks.typ`, `adapter.typ`; `lib.typ` (repository root) | renderers bound to section keys; the render pipeline; the template's page footers (`alta-footer`, `alta-updated-footer`) and what they print of a CV; the public blocks for a CV written in markup (`entry`, `cv-header`, `publication`, …), over the components and `data/` readers; the public `adapter` readers for a mapping of your own (`adapter-helpers.typ`, re-exported alone by `adapter.typ`), over the same readers, so importing no section; the public API, as re-exports only | everything |

The two rules that matter: **components never read the CV** (no `data/`, no `util/fields.typ`: values arrive through slots), so a change to JSON Resume's shape touches only sections and `data/`; **data never imports UI**, so checking the CV doesn't depend on rendering. `data/` may import `design/` because design is plain values (themes, palettes, the icon set), with no rendering code.

Parts a user can restyle with a show rule (the README's Restyling parts) are labelled through `_part` (`design/styles.typ`), on the raw value where it last appears unstyled, with any styling (`upper()`, a treatment) applied around it; a paragraph part (`<alta-keywords>`) labels the `par` that lays out a row, so `set par(...)` reaches it. That puts each label in the layer that renders its part: a heading's in its show rule (`design/styles.typ`), the footer's in `_standalone` and the footer helpers. A helper that may receive a part puts its own label on a new element, so the part keeps its label: a keyword drawn by `tag()` is both `<alta-keyword>` and `<alta-pill>`. `_part` never skips labelled content, which would unlabel a user's own labelled values. Labels the template only uses for its own rules are prefixed `alta-internal-`; every other `alta-` label is public API, listed in the README.

## The adapter layer

Inside the template, `alta()` draws through the JSON Resume mapping, `adapter/json-resume.typ` at the repository root: `resume(cv, labels:, preferences:)`, written only with what `lib.typ` exports, so a user can copy it, swap its imports for one `@preview/altacv` import and edit it (`tests/unit/mapping-imports.typ` holds it to that). It imports the public names from the modules that define them, as `render.typ`, which calls it, sits inside `lib.typ`. What it needs beyond the blocks comes from two modules in the root layer:

- `adapter-helpers.typ`: the public readers (`format-date`, `location-text`, `basics-contacts`, `fluency-rating`, `group-by-type`, `labels`), thin wrappers over the `data/` readers `alta()` uses, with the preferences they read passed explicitly, taking JSON Resume's camelCase field names.
- `adapter.typ`: re-exports exactly those, which `lib.typ` exports as the `adapter` module. Typst re-exports every name a module imports, so the helpers' own imports would otherwise leak into it.

Everything the mapping draws is overridable the Typst way: block arguments, the template's show rule for `<alta-intro>`'s spacing, the surrounding `align`. It hardcodes no theme value.

## Sections and components

A section reads fields and fills a component's slots:

```typst
// sections/awards.typ
#let _awards(entries, (labels, format-date, ..)) = _section(
  labels.awards,
  entries,
  award => _entry(
    title: award.title,
    url: _altacv(award, "url"),
    org: _field(award, "awarder"),
    period: (format-date(_field(award, "date")),),
    summary: _field(award, "summary"),
  ),
)
```

Renderers take their entries and `ctx`: the labels, the preferences, `format-date` (bound to `date-format` and `labels.months`), the CV `owner` and `owners` (every spelling of the owner's name, normalised). A section doesn't check or filter its input: step 2 checked every field it draws and dropped the entries that don't render, so it only maps values onto slots. A few fields are read leniently instead, by design; the `_section-specs` comment lists them. Column sections are registered twice: their spec (field, default column, accepted entries, field types, which entries render, other checks) in `data/sections.typ`, their renderer in `registry.typ`. The header, intro and footer aren't columns; `alta()` calls them directly, with the same `(cv, ctx)`. Facts reach the entry components as data, not joined lines: `_entry` takes its organisation as a value and its roles, details, period, location, subtitle, keywords-lead and keywords as parts or fact groups, `_bib-entry` its authors, citation and identifiers as records, and each does every join with the theme's separators. A section may still build styled leaf content from primitives to pass as a slot, e.g. the header's photo and contact values (the location joined there) and the references' on-request note.

## The look

- **`design/theme.typ`**: plain data. `_tokens` are the font, the scales and their defaults: Material 3 type roles (`display` … `body`), the colour roles (the default theme's), separators and treatments, CSS size keywords for `space`, plus weights, stroke widths and leading. `_build-theme` maps them onto component roles, deriving `secondary` and `border` from `body`. `_theme-for` builds the theme to render with, once per render in `_document`: the chosen theme's tokens, then the preferences that override them (`_token-prefs`: `font`, `colours`), deep-merged over `_tokens`. Every component reads it from state in `context`. Helpers that return `none` for an empty line (`_fact-line`, `_preamble`) decide that from their parts first, outside `context`, and read the theme only to format what's there. Sizes multiply the text size where a part renders (`text.size`, read in `context`), the body's inside `alta()`; a treatment is a function of the content, applied where its part renders.
- **`design/presets.typ`**: the built-in `themes`, one file each under `design/presets/` (the default colours in `_tokens` are `presets/teal.typ`'s), and the deprecated `palettes`, built from them. Each theme is a set of `_tokens` overrides; the built-in ones set every colour role. A caller's theme may set any tokens, any subset of them: validation (`_check-tokens`) checks it against `_tokens`' shape, so an unknown key or a value of the wrong kind panics with its path.
- **`context.typ`**: the built themes and rating scale, as `state`. The themes are a stack, innermost template last: `_document` pushes its theme and, for `altacv`, pops it after its body, so content after a nested, scoped template reads the outer one; standalone `alta()`'s theme stays pushed for the content after it. Components and the public helpers (`tag`, `rating`, …), which may sit anywhere in a user's document, read the current theme with `_theme()` in `context`; the style rules (`_base-styles`, `_label-headings`, `_level-headings`) take it from `_document`, `_standalone` and `altacv` directly.

Users style through [preferences](README.md#preferences) and show rules, in that order of precedence: `theme` picks a theme (`themes.teal` unless set), `font` and `colours` override its font and colour roles, and a show rule on a labelled part overrides all of them. A new look is a part or a theme token, not a preference ([design conventions](CONTRIBUTING.md#design-conventions)).

## Deprecations

`data/canonical.typ` rewrites each deprecated input into its current form before validation, so nothing downstream sees it. [#239](https://github.com/smur89/alta-typst/issues/239) lists the 2.0.0 removals.
