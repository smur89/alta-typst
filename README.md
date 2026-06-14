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
#import "@preview/altacv:1.0.0": alta // x-release-please-version
```

## Quick start

```typst
#import "@preview/altacv:1.0.0": alta // x-release-please-version

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
      url: "https://acme.example.com", // optional — wraps the company name in a link
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

- `focusAreas`: top-level array of prose items. This is an intentional altacv addition, distinct from JSON Resume's `interests` (which is structured `{name, keywords}` per entry — also supported, see below). Rendered as a bulleted "Areas of Focus" section.
- `languages[].rating`: numeric 0–`preferences.maxRating` (default 5; JSON Resume uses a `fluency` string; supplying `rating` enables half-dot precision and wins over `fluency` if both are present).
- `publications[].type`: optional grouping key (e.g. `"Articles"`, `"Books"`, `"Talks"`). Entries sharing a `type` cluster under a subheading rendered verbatim from the string; entries without `type` fall under `labels.articles`. Localise either by overriding `labels.articles` or by supplying already-translated `type` values directly.

Each `publications[]` entry renders as title, then (if supplied) `publisher` on the line below in body colour, `releaseDate` in a lighter shade, and `summary` as a paragraph. `name`, `publisher`, `releaseDate`, `url`, and `summary` are all optional — omitted fields simply drop their line.

An empty or missing `endDate` is interpreted as the role still being current and renders as `Present` (localisable via `labels.present`).

Top-level keys recognised: `basics`, `focusAreas`, `work`, `volunteer`, `skills`, `languages`, `education`, `certificates`, `awards`, `projects`, `publications`, `interests`, `meta` (PDF metadata only — see [PDF metadata](#pdf-metadata)). Any section with empty input is skipped — no orphan headings.

`basics.url` (JSON Resume's canonical "personal homepage" field) is rendered in the contact bar with the generic `link` icon, alongside `email`, `phone`, `location`, and `profiles`. It's distinct from a `basics.profiles` entry with `network: "Website"` (which represents a profile *on* a third-party site); supply both if you want both rendered.

JSON Resume keys **not yet rendered** by this template: `references`. Track or upvote feature requests on the issue tracker if you need any of them.

`basics.location` accepts either a plain string or JSON Resume's structured dict `{address, postalCode, city, countryCode, region}`. A string flows verbatim into the contact bar and the maps deep link. A dict is collapsed to a single line by joining the CV-relevant subset — `city`, `region`, `countryCode` — with `", "`, skipping any field that's missing or empty (so `(city: "Dublin", region: "Leinster", countryCode: "IE")` renders as `Dublin, Leinster, IE`, and `(city: "Tokyo")` renders as `Tokyo`). `address` and `postalCode` are accepted (so a verbatim `resume.json` dict round-trips without panicking) but not rendered — a CV header isn't a mailing label. The same joined string also drives the maps deep link, so display and link stay in sync. Unknown keys panic. If you need the legacy verbatim behaviour for a value that doesn't fit the dict shape, pass it as a string.

### Portrait (`basics.image`)

Setting `basics.image` adds a circular portrait to the top-right of the header (move it with `preferences.imagePosition` — `"left"` / `"right"` for the two-column layout, or `"center"` to stack the portrait on its own centred row above or below the text block via `preferences.imageStackOrder`). Two ways to supply the source:

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

### Work

Each `work[]` entry follows JSON Resume's schema. Practical subset supported:

| Field | Type | Effect |
|---|---|---|
| `position` | string | Job title. Rendered as the entry heading. |
| `name` | string | Company / employer name, rendered in the accent colour beneath the title; wrapped in a link when `url` is supplied. |
| `url` | string | If supplied, wraps `name` in a link. Visual treatment is unchanged (bold accent, no italic / underline) — clickable in viewers that honour PDF links. |
| `location` | string | Optional location, rendered alongside the date range via the location-icon row. |
| `startDate` / `endDate` | string | Date range. Omit `endDate` (or pass an empty string) to render "Present" (localisable via `labels.present`). |
| `summary` | string or content | Short paragraph describing the role, rendered as an italic preamble between the date row and the highlights list. Pass `[...]` content (e.g. `[Owned the _event-sourcing_ stack.]`) to get markup; plain strings render verbatim. |
| `description` | string or content | Alternative spelling used by some JSON Resume exporters — rendered identically to `summary`, but `summary` wins when both are supplied. |
| `highlights` | array of content | Bulleted list of accomplishments / contributions. |

### Awards

Each `awards[]` entry follows JSON Resume's schema, plus a `url` extension:

| Field | Type | Effect |
|---|---|---|
| `title` | string | Award name. Rendered as the entry heading; linked to `url` when supplied. Entries with missing or empty `title` are silently skipped. |
| `awarder` | string | Granting organisation, rendered in the accent colour beneath the title (same treatment as `education[].institution`). |
| `date` | string | Single date (not a range). Renders via the calendar-icon row. |
| `url` | string | If supplied, wraps the title in an accent-coloured link. Not in the JSON Resume spec — an altacv extension for linking to a paper, conference page, or write-up. |
| `summary` | string or content | Short description, rendered as a paragraph below the date. Pass `[...]` content (e.g. `[For _Idempotent Kafka Consumers_.]`) to get markup like emphasis; plain strings render verbatim. |

### Projects

Each `projects[]` entry follows JSON Resume's schema. Practical subset supported:

| Field | Type | Effect |
|---|---|---|
| `name` | string | Project title. Rendered as a heading; linked to `url` when supplied. Entries with missing or empty `name` are silently skipped. |
| `description` | string | Short subtitle under the title, rendered in body colour as italic. |
| `url` | string | If supplied, wraps the title in an accent-coloured link. |
| `startDate` / `endDate` | string | Date range, same conventions as `work` entries (omit `endDate` → "Present"). |
| `highlights` | array of content | Bulleted list of accomplishments / contributions. |
| `keywords` | array of strings | Renders as a row of pill tags below the highlights. |

`entity`, `type`, and `roles` from the JSON Resume spec are accepted (silently ignored) but not yet rendered. Open an issue if you need them.

### Volunteer

Each `volunteer[]` entry follows JSON Resume's schema — the same shape as `work[]`, but with `organization` in place of `name`:

| Field | Type | Effect |
|---|---|---|
| `position` | string | Role title. Rendered as the entry heading. |
| `organization` | string | Granting organisation, rendered in the accent colour beneath the position (same treatment as `work[].name`). |
| `location` | string | Optional location, rendered next to the date range. |
| `startDate` / `endDate` | string | Date range, same conventions as `work` entries (omit `endDate` → "Present"). |
| `highlights` | array of content | Bulleted list of accomplishments / contributions. |

`summary` and `url` from the JSON Resume spec are accepted (silently ignored) but not yet rendered. Open an issue if you need them.

By default `volunteer` renders in the left column directly below `work`, so volunteering reads as a continuation of the experience block. Move it to the right column (or reorder it within the left) via `preferences.leftColumnSections` / `preferences.rightColumnSections` like any other section.

### Education

Each `education[]` entry follows JSON Resume's schema. Practical subset supported:

| Field | Type | Effect |
|---|---|---|
| `institution` | string | School name. Rendered in accent-bold beneath the qualification title; wrapped in a link to `url` when supplied. |
| `url` | string | If supplied, wraps the institution name in an accent-bold link (preserving the styling, just clickable). |
| `studyType` | string | Qualification (e.g. "M.Sc. in Computer Science"). Rendered as the entry heading. Falls back to `area` if absent. |
| `area` | string | Field of study. Used as the heading only when `studyType` is missing. |
| `startDate` / `endDate` | string | Date range, same conventions as `work` entries (omit `endDate` → "Present"). |
| `score` | string | Grade / classification, rendered as a plain line below the date range. |
| `courses` | array of strings | Relevant course / module names. Rendered as a row of pill tags below the score — same treatment as `skills[].keywords` and `projects[].keywords`. |

### Publications

Each `publications[]` entry follows JSON Resume's schema, with one altacv-specific extension (`type`). Practical subset supported:

| Field | Type | Effect |
|---|---|---|
| `name` | string | Publication title. Rendered as the bullet body; linked to `url` when supplied, italicised when not. |
| `publisher` | string | Rendered as a subtitle below the title, in body colour at 0.85em. |
| `releaseDate` | string | Single date (not a range). Rendered below the publisher in a lighter shade. |
| `url` | string | If supplied, wraps the title in an accent-coloured link. |
| `summary` | string or content | Short description, rendered as a paragraph below the date. Pass `[...]` content (e.g. `[A walk-through of _idempotent Kafka consumers_.]`) to get markup like emphasis; plain strings render verbatim. |
| `type` | string | altacv extension. Optional grouping key (e.g. `"Articles"`, `"Books"`, `"Talks"`). Entries sharing a `type` cluster under a subheading rendered verbatim from the string; entries without `type` fall under `labels.articles`. |

### Certificates

Each `certificates[]` entry follows JSON Resume's schema:

| Field | Type | Effect |
|---|---|---|
| `name` | string | Certificate name. Rendered as a pill tag; linked to `url` when supplied. Entries with missing or empty `name` are silently skipped. |
| `issuer` | string | Granting organisation. Never rendered, but drives the grouping when `preferences.groupCertificates` is `true` — certs from the same issuer cluster into a single pill row. |
| `date` | string | Single date (not a range). Rendered as small body-coloured text inline immediately to the right of the pill, sharing the same baseline. |
| `url` | string | If supplied, wraps the pill in a link to the credential. |

### Interests

Each `interests[]` entry follows JSON Resume's `{name, keywords}` shape — the same shape as `skills[]`, and rendered with the same pill-tag layout (the `name` as a label-tag, each `keywords` entry as a regular tag). Use it for personal interests / hobbies; reach for `focusAreas` instead when you want prose-style bullets.

| Field | Type | Effect |
|---|---|---|
| `name` | string | Category label, rendered as the leading "label" pill on the row. |
| `keywords` | array of strings | Items in the category, rendered as a row of pill tags after the label. Entries with an empty `keywords` array are silently skipped. |

```typst
interests: (
  (name: "Music", keywords: ("Trad", "Jazz")),
  (name: "Sport", keywords: ("Hurling", "Climbing")),
)
```

### Profile networks

The `network` field of each `basics.profiles` entry is matched case-insensitively against a vendored icon set. Built-in networks: `Bluesky`, `GitHub`, `GitLab`, `Link`, `LinkedIn`, `Mastodon`, `Medium`, `Stackoverflow`, `Twitter` (alias: `X`), `Website`. Use `Link` as a generic fallback for any URL without a brand. Unknown networks panic with a list of the supported set. To add another, drop its SVG (with `fill="#666666"` baked in) into `icons/` and register it in `_network_icon_sources` in `lib.typ`.

### PDF metadata

The rendered PDF carries metadata in its document properties — what your OS shows in "Get Info" / "Properties" and what indexing services (CV review tools, search) read. Fields are populated from the data dict; each is only written when its source is non-empty.

| PDF field | Source | Notes |
|---|---|---|
| Title | `basics.name + " --- CV"` | Always set. |
| Author | `basics.name` | Always set; canonical (ignores `preferences.uppercaseName`). |
| Subject (description) | `basics.summary` | Same content rendered in the document header. |
| Keywords | `skills[].keywords` | Flattened across every skill group and de-duplicated, insertion order preserved. |
| Date (CreationDate / ModDate) | `meta.lastModified` | ISO 8601 — either `YYYY-MM-DD` or a full `YYYY-MM-DDTHH:MM:SSZ` timestamp; only the calendar part is used. Falls back to compile time when `meta.lastModified` is absent or unparseable. |

The `meta` block is otherwise unrendered — `canonical` and `version` are accepted (for round-trip with JSON Resume sources) but currently have no visible or metadata effect.

To also surface "last updated" in the rendered document, set `preferences.lastModifiedFooter: true` — see the [preferences table](#preferences).

```typst
meta: (
  canonical: "https://example.com/cv.json", // accepted, currently unrendered
  version: "1.0.0",                         // accepted, currently unrendered
  lastModified: "2026-06-12",               // → PDF date + optional footer
)
```

## Configuration

### `alta()` arguments

```typst
#alta(cv, labels: (:), preferences: (:))
```

Just three arguments. `cv` is the data dict; `labels` and `preferences` are partial dicts that shallow-merge over the built-in defaults (unknown keys panic — catches typos).

### Preferences

Every theme, font, layout, and behaviour knob lives in `preferences`. Override any subset; the rest fall back to defaults.

| Key | Default | Effect |
|---|---|---|
| `font` | `"Lato"` | Primary font family. Must be installed. |
| `bodySize` | `10pt` | Base text size. Every sub-element scales from this via em-multipliers. |
| `paper` | `"a4"` | Standard paper size — string passed to Typst's `set page(paper: ...)`. Supports `"a4"`, `"us-letter"`, `"a5"`, `"us-legal"`, and the rest of [Typst's named papers](https://typst.app/docs/reference/layout/page/#parameters-paper). |
| `margin` | `(x: 0.9cm, y: 1.5cm)` | Page margins. Anything `set page(margin: ...)` accepts works. |
| `accent` | `rgb("#00796B")` | Theme colour for headings, accent rules, tags, dots. |
| `groupCertificates` | `true` | When true, group certificates by issuer (2+ certs from the same issuer cluster; singletons pool into a final "other" group). When false, render flat. |
| `imageSize` | `6em` | Diameter of the circular portrait when `basics.image` is set. Ignored when no image is supplied. |
| `imagePosition` | `"right"` | Where the portrait sits in the header — `"left"` or `"right"` (two-column header) or `"center"` (portrait on its own centred row, stacked with the text block). Ignored when no image is supplied. |
| `imageStackOrder` | `"above"` | Stack order when `imagePosition` is `"center"` — `"above"` puts the portrait above the name/label/contact block; `"below"` puts it underneath (the "photo as sign-off" look). Ignored for `"left"` / `"right"` positions. |
| `headerTextAlign` | `"left"` | Horizontal alignment of the header text (name, label, contact bar). Applies whether or not `basics.image` is set, so it also centres the header on image-less CVs. One of `"left"`, `"right"`, `"center"`. The default keeps every line starting at the same edge regardless of which side the photo is on; flip to `"right"` for the mirrored "text hugs the opposite edge" look. |
| `uppercaseName` | `true` | When `true` (the default — matching AltaCV's visual ancestor), `basics.name` renders in uppercase. Set to `false` to render the name as supplied. Useful for scripts where uppercase is a different glyph set (Turkish dotless-i, etc.), scripts that have no case at all, or simply when the loud uppercase look isn't wanted. |
| `lastModifiedFooter` | `false` | When `true` and `meta.lastModified` is set, renders a small right-aligned `Last updated: <meta.lastModified>` line in the page footer. The label text is localisable via `labels.lastModified`; the timestamp is rendered as supplied (the full ISO 8601 string flows through verbatim). PDF metadata (date / keywords / description) is enriched from `meta` / `basics` independently of this flag — see [PDF metadata](#pdf-metadata). |
| `linkContactInfo` | `true` | Controls whether contact-bar entries are wrapped in deep links (`mailto:`, `tel:`, the configured maps URL for location — see `mapsProvider`, the supplied URL for `basics.url` and for each profile). Accepts a **boolean** (`true` / `false`, applied uniformly to every channel) or a **partial dict** keyed by channel — `"email"`, `"phone"`, `"location"`, `"url"`, `"profiles"` — so you can opt out per channel without touching the data. E.g. `linkContactInfo: (phone: false)` keeps email / location / homepage / profile links but renders the phone as plain text. Omitted channels stay linked; unknown channel keys panic. |
| `mapsProvider` | `maps-providers.google` | URL template for the `basics.location` deep link. The `{q}` placeholder is replaced with the URL-encoded location at render time. Use a built-in template — `maps-providers.{google,apple,bing,duckduckgo,osm}`, all exported from the module — or pass any other URL template string for a provider that isn't built in (no code change required). Pass `none` to suppress the link entirely (icon + plain text still render). Strings missing `{q}` panic; non-string / non-`none` values panic. |
| `columnRatio` | `0.64` | Left-column width as a fraction of the page (strictly between 0 and 1). The right column gets the remainder minus a fixed gutter. Halve it to invert the layout. |
| `pageFooter` | `none` | Optional page footer. `none` — no footer (default). `"auto"` — emits a footer on **multi-page** documents only, with `basics.name` flush left and `Page N / M` flush right, sized at `0.8em` in the body colour; the single-page case stays clean. Any **content** value (`[…]`, `align(...)`, etc.) — rendered verbatim as the footer on every page. Anything else panics. When set (non-`none`), takes precedence over `lastModifiedFooter` — the two prefs target overlapping surface so a non-default `pageFooter` wins; combine the "last updated" line yourself in a content footer if you want both. |
| `leftColumnSections` | `("work", "volunteer")` | Sections to render in the left column, in order. |
| `rightColumnSections` | `("focusAreas", "skills", "languages", "education", "certificates", "awards", "projects", "publications", "interests")` | Sections to render in the right column, in order. |
| `maxRating` | `5` | Number of dots on the language fluency scale. Must be a positive integer. The default matches LinkedIn's 0–5 scale (and the built-in `fluency` string map); set to `6` for CEFR (A1–C2), `4` for ILR-style 0–4, or any other positive integer for a custom scale. Fluency strings remain anchored to the 0–5 LinkedIn scale, so callers using a non-5 `maxRating` must supply numeric `languages[].rating` values. |

Both column arrays draw from the same set of section keys: `"work"`, `"volunteer"`, `"focusAreas"`, `"skills"`, `"languages"`, `"education"`, `"certificates"`, `"awards"`, `"projects"`, `"publications"`, `"interests"`. Sections omitted from both arrays are not rendered, even if their data is present; sections listed in both render twice. Unknown keys panic.

Section renderers are width-agnostic — they fill whichever column they end up in. Combined with `columnRatio`, this enables layouts like an inverted CV where the side-panel sections take the narrow left column and the experience block spans a wider right column.

Example — reorder the right-column sections + tweak theme + use US Letter:

```typst
#alta(cv, preferences: (
  paper: "us-letter",
  accent: rgb("#1976D2"),
  groupCertificates: false,
  imageSize: 7em,
  // Render the contact bar as plain text (no mailto:/tel:/maps links).
  linkContactInfo: false,
  // Use OpenStreetMap for the `basics.location` link (the
  // `maps-providers` dict is re-exported by the module — `import` it
  // alongside `alta` to use a built-in).
  mapsProvider: maps-providers.osm,
  // Move education above skills; hide publications.
  rightColumnSections: ("focusAreas", "education", "skills", "languages", "certificates"),
))
```

Example — invert the template (side panel on the narrow left, experience on the wide right):

```typst
#alta(cv, preferences: (
  // columnRatio is the LEFT column's width fraction. The historic
  // experience-left layout uses 0.64; halving it to 0.36 turns the
  // left column into the narrow side panel and gives the (now
  // right-hand) experience block the wider share.
  columnRatio: 0.36,
  leftColumnSections: ("focusAreas", "skills", "languages", "education", "certificates"),
  rightColumnSections: ("work", "publications"),
))
```

Example — opt out of links per channel (everything stays linked except phone):

```typst
#alta(cv, preferences: (
  // Bool form would turn every contact link on or off uniformly;
  // the dict form lets you keep some channels linked while turning
  // others into plain text. Omitted channels stay at the default
  // (`true` — linked).
  linkContactInfo: (phone: false),
))
```

### Labels

All display strings the template emits. Override any subset via `labels:`; the rest fall back to English defaults. Unknown keys panic. Use this for translation or local renaming.

Label keys match the JSON Resume section keys (`work`, `certificates`, …) so the data-field name and the heading-override key are the same. The default *values* still read "Experience" and "Certifications" — that's editorial.

| Key | Default |
|---|---|
| `work` | `"Experience"` |
| `volunteer` | `"Volunteer"` |
| `focusAreas` | `"Areas of Focus"` |
| `skills` | `"Skills"` |
| `languages` | `"Languages"` |
| `education` | `"Education"` |
| `certificates` | `"Certifications"` |
| `publications` | `"Publications"` |
| `awards` | `"Awards"` |
| `projects` | `"Projects"` |
| `interests` | `"Interests"` |
| `articles` | `"Articles"` |
| `present` | `"Present"` |
| `lastModified` | `"Last updated"` |

Example (German + rename "Skills" to "Core Technologies"):

```typst
#alta(cv, labels: (
  work:         "Berufserfahrung",
  focusAreas:   "Schwerpunkte",
  skills:       "Core Technologies",
  languages:    "Sprachen",
  education:    "Ausbildung",
  certificates: "Zertifikate",
  publications: "Veröffentlichungen",
  present:      "Heute",
))
```

### Helpers

The template also exports lower-level helpers for callers who want to compose custom layouts:

| Helper | Purpose |
|---|---|
| `icon(name, size: auto, shift: auto, fill: auto)` | Render a vendored SVG. `name` is any key from the built-in icon set (utility or network). |
| `name(body)` | Bold accent-coloured line — designed for the company / institution row under a role. |
| `term(period, location: none)` | Two half-width boxes for a date range and optional location, each with their leading icon. |
| `rating(label, value)` | Label on the left, filled / half-filled / empty dots on the right. `value` is numeric 0–`preferences.maxRating` (default 5). Drives the language fluency dots; works for any row on the configured scale. (Shares a name with the `languages[].rating` data field because both describe the same scale — the function isn't auto-fed from the data; pass the value explicitly.) |
| `tag(body, label: false)` | Pill-style tag; `label: true` for a darker, bold "category" variant. |
| `divider()` | Dashed grey rule used between entries within a section. |
| `styled-link(dest, content)` | Accent-coloured italic underlined link — used for publication titles. |

```typst
#import "@preview/altacv:1.0.0": tag, divider // x-release-please-version
```

The contact bar (rendered from `basics.email`, `basics.phone`, `basics.location`, `basics.url`, and `basics.profiles`) wires each entry to a deep link: `mailto:` for email, `tel:` for phone (visual separators stripped from the dialable part), the configured maps URL for location, and the supplied URL for the homepage and each profile. Suppress or swap any of them via `preferences.linkContactInfo` and `preferences.mapsProvider` above.

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
