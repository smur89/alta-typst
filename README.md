# altacv

A Typst CV template inspired by LianTze Lim's [AltaCV](https://github.com/liantze/AltaCV) (LaTeX). Data-driven via a [JSON Resume](https://jsonresume.org/)-style dict; configurable theme, labels, and sections.

<!-- Preview image is committed under examples/preview.png and served
     via raw.githubusercontent so it resolves both on the GitHub repo
     page and the Typst Universe package page (the package archive
     only ships lib.typ, icons/, LICENSE, README.md, so a relative
     path would not resolve on Universe). CI also uploads a fresh
     preview.png as a workflow artifact on each run for reviewers. -->
![Two-column CV rendered by the altacv template — left column shows experience; right column shows areas of focus, skills, languages, education, certifications, and publications](https://raw.githubusercontent.com/smur89/alta-typst/main/examples/preview.png)

## Installation

Available on [Typst Universe](https://typst.app/universe/package/altacv):

```typst
#import "@preview/altacv:0.3.3": alta // x-release-please-version
```

## Quick start

```typst
#import "@preview/altacv:0.3.3": alta // x-release-please-version

#let cv = (
  basics: (
    name: "Jane Doe",
    label: "Senior Software Engineer",
    summary: [Backend engineer with eight years' experience…],
    email: "jane@example.com",
    phone: "+353 1 555 0100",
    location: "Dublin, Ireland",
    profiles: (
      (network: "LinkedIn", username: "janedoe",     url: "https://linkedin.com/in/janedoe"),
      (network: "GitHub",   username: "janedoe",     url: "https://github.com/janedoe"),
      (network: "Website",  username: "janedoe.dev", url: "https://janedoe.dev"),
    ),
  ),
  work: (
    (
      name: "Acme Corp",
      position: "Senior Software Engineer",
      location: "Dublin, Ireland",
      startDate: "Jan 2022",
      // omit endDate → renders as "Present"
      highlights: ([Led the migration…], [Designed the platform…]),
    ),
  ),
  skills: (
    (name: "Languages", keywords: ("Scala", "Python")),
    (name: "Infra",     keywords: ("Kafka", "AWS", "Kubernetes")),
  ),
  languages: (
    (language: "English", fluency: "Native"),
    (language: "Irish",   fluency: "Professional Working"),
  ),
  // … education, certificates, publications
)

#alta(cv)
```

See `examples/example.typ` in the [source repository](https://github.com/smur89/alta-typst) for a one-page CV covering the main sections. Edge cases (publication grouping, fractional language ratings, custom preferences) are exercised by fixtures under `tests/`.

## Data schema

The `cv` dict follows [JSON Resume](https://jsonresume.org/schema/) with three practical extensions:

- `focusAreas`: top-level array of prose items. This is an intentional altacv addition, distinct from JSON Resume's `interests` (which is structured `{name, keywords}` per entry). Rendered as a bulleted "Areas of Focus" section.
- `languages[].rating`: numeric 0–5 (JSON Resume uses a `fluency` string; supplying `rating` enables half-dot precision and wins over `fluency` if both are present).
- `publications[].type`: optional grouping key (e.g. `"Articles"`, `"Books"`, `"Talks"`). Entries sharing a `type` cluster under a subheading rendered verbatim from the string; entries without `type` fall under `labels.articles`. Localise either by overriding `labels.articles` or by supplying already-translated `type` values directly.

An empty or missing `endDate` is interpreted as the role still being current and renders as `Present` (localisable via `labels.present`).

Top-level keys recognised: `basics`, `focusAreas`, `work`, `skills`, `languages`, `education`, `certificates`, `awards`, `publications`. Any section with empty input is skipped — no orphan headings.

JSON Resume keys **not yet rendered** by this template: `interests` (the structured `{name, keywords}` form — see `focusAreas` for the prose alternative), `projects`, `volunteer`, `references`, `meta`, `basics.url`. Track or upvote feature requests on the issue tracker if you need any of them.

### Portrait (`basics.image`)

Setting `basics.image` adds a circular portrait to the top-right of the header. Two ways to supply the source:

```typst
// Recommended: load the bytes in your own typ file. Path resolution
// happens at your call site, so relative paths "just work".
basics: (
  image: read("avatar.png", encoding: none),
  ...
)

// Alternative: a root-relative path (leading "/", anchored to the
// `--root` directory passed to `typst compile`). String paths without
// a leading "/" resolve relative to `lib.typ` and are not portable.
basics: (
  image: "/avatar.png",
  ...
)
```

JSON Resume's spec calls for a URL here — Typst does not fetch remote URLs at compile time, so a https:// URL will not work. Vendor the asset locally and use one of the two forms above.

Size is configurable via `preferences.imageSize` (default `6em`). The image is fit with `cover` and clipped to a circle, so rectangular sources crop centred rather than distort.

### Awards

Each `awards[]` entry follows JSON Resume's schema:

| Field | Type | Effect |
|---|---|---|
| `title` | string | Award name. Rendered as the entry heading. Entries with missing or empty `title` are silently skipped. |
| `awarder` | string | Granting organisation, rendered in the accent colour beneath the title (same treatment as `education[].institution`). |
| `date` | string | Single date (not a range). Renders via the calendar-icon row. |
| `summary` | string or content | Short description, rendered as a paragraph below the date. Pass `[...]` content (e.g. `[For _Idempotent Kafka Consumers_.]`) to get markup like emphasis; plain strings render verbatim. |

### Profile networks

The `network` field of each `basics.profiles` entry is matched case-insensitively against a vendored icon set. Built-in networks: `Bluesky`, `GitHub`, `GitLab`, `Link`, `LinkedIn`, `Mastodon`, `Medium`, `Stackoverflow`, `Twitter` (alias: `X`), `Website`. Use `Link` as a generic fallback for any URL without a brand. Unknown networks panic with a list of the supported set. To add another, drop its SVG (with `fill="#666666"` baked in) into `icons/` and register it in `_network_icon_sources` in `lib.typ`.

## Configuration

### Top-level `alta()` arguments

These are page-geometry primitives:

| Argument | Default | Purpose |
|---|---|---|
| `font` | `"Lato"` | Primary font family. Must be installed. |
| `body-size` | `10pt` | Base text size. Every sub-element scales from this via em-multipliers. |
| `paper` | `"a4"` | Page format. |
| `margin` | `(x: 0.9cm, y: 1.5cm)` | Page margins. |
| `column-ratio` | `0.64` | Left/right column split (experience vs side panel). |
| `labels` | `(:)` | Override section headings — see [Labels](#labels). |
| `preferences` | `(:)` | Override theme + behaviour toggles — see [Preferences](#preferences). |

### Preferences

Theme + behaviour configuration. Override any subset via `preferences:`; the rest fall back to defaults. Unknown keys panic (catches typos).

| Key | Default | Effect |
|---|---|---|
| `accent` | `rgb("#00796B")` | Theme colour for headings, accent rules, tags, dots. |
| `groupCertificates` | `true` | When true, group certificates by issuer (2+ certs from the same issuer cluster; singletons pool into a final "other" group). When false, render flat. |
| `imageSize` | `6em` | Diameter of the circular portrait when `basics.image` is set. Ignored when no image is supplied. |

Example:

```typst
#alta(cv, preferences: (
  accent: rgb("#1976D2"),
  groupCertificates: false,
  imageSize: 7em,
))
```

### Labels

All display strings the template emits. Override any subset via `labels:`; the rest fall back to English defaults. Unknown keys panic. Use this for translation or local renaming.

| Key | Default |
|---|---|
| `experience` | `"Experience"` |
| `focusAreas` | `"Areas of Focus"` |
| `skills` | `"Skills"` |
| `languages` | `"Languages"` |
| `education` | `"Education"` |
| `certifications` | `"Certifications"` |
| `publications` | `"Publications"` |
| `awards` | `"Awards"` |
| `articles` | `"Articles"` |
| `present` | `"Present"` |

Example (German + rename "Skills" to "Core Technologies"):

```typst
#alta(cv, labels: (
  experience:     "Berufserfahrung",
  focusAreas:     "Schwerpunkte",
  skills:         "Core Technologies",
  languages:      "Sprachen",
  education:      "Ausbildung",
  certifications: "Zertifikate",
  publications:   "Veröffentlichungen",
  present:        "Heute",
))
```

### Helpers

The template also exports lower-level helpers for callers who want to compose custom layouts:

| Helper | Purpose |
|---|---|
| `icon(name, size: auto, shift: auto, fill: auto)` | Render a vendored SVG. `name` is any key from the built-in icon set (utility or network). |
| `name(body)` | Bold accent-coloured line — designed for the company / institution row under a role. |
| `term(period, location: none)` | Two half-width boxes for a date range and optional location, each with their leading icon. |
| `skill(name, rating)` | Name on the left, five filled / half-filled / empty dots on the right. `rating` is numeric 0–5. |
| `tag(body, label: false)` | Pill-style tag; `label: true` for a darker, bold "category" variant. |
| `divider()` | Dashed grey rule used between entries within a section. |
| `styled-link(dest, content)` | Accent-coloured italic underlined link — used for publication titles. |

```typst
#import "@preview/altacv:0.3.3": tag, divider // x-release-please-version
```

The contact bar (rendered from `basics.email`, `basics.phone`, `basics.location`, and `basics.profiles`) wires each entry to a deep link: `mailto:` for email, `tel:` for phone (visual separators stripped from the dialable part), and a Google Maps search URL for location. These are not currently configurable; if you need to suppress them or swap providers, please open a feature request.

## Building the example

```sh
typst compile --root . examples/example.typ examples/example.pdf
```

To regenerate the preview image:

```sh
typst compile --root . --format png --ppi 150 examples/example.typ 'examples/preview-{p}.png'
mv examples/preview-1.png examples/preview.png && rm examples/preview-*.png
```

## Credits

- **[LianTze Lim — AltaCV](https://github.com/liantze/AltaCV)** (LPPL). The visual ancestor: the two-column layout, accent palette, and section structure originate in LianTze's LaTeX class.
- **[George Honeywood — alta-typst](https://github.com/GeorgeHoneywood/alta-typst)** (MIT, © 2023). Prior Typst implementation; the grid layout, pill tags, and half-fill skill dots originate there.

## License

[MIT](LICENSE). Copyright © 2023 George Honeywood, © 2026 Shane Murphy.
