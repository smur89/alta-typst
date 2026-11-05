<h1 align="center">Alta CV</h1>

<p align="center">
  <a href="https://typst.app/universe/package/altacv"><img alt="altacv on Typst Universe" src="https://img.shields.io/badge/dynamic/xml?url=https%3A%2F%2Ftypst.app%2Funiverse%2Fpackage%2Faltacv&query=%2Fhtml%2Fbody%2Fdiv%2Fmain%2Fdiv%5B2%5D%2Faside%2Fsection%5B2%5D%2Fdl%2Fdd%5B3%5D&logo=typst&label=Universe&color=%23239DAE&style=flat-square"></a>
  <a href="https://github.com/smur89/alta-typst/releases"><img alt="Latest GitHub release version of altacv" src="https://img.shields.io/github/v/release/smur89/alta-typst?style=flat-square"></a>
  <a href="https://github.com/smur89/alta-typst/actions/workflows/build.yml"><img alt="GitHub Actions build workflow status on the altacv main branch" src="https://img.shields.io/github/actions/workflow/status/smur89/alta-typst/build.yml?style=flat-square"></a>
  <a href="LICENSE"><img alt="MIT license badge linking to the altacv LICENSE file" src="https://img.shields.io/github/license/smur89/alta-typst?style=flat-square"></a>
  <a href="https://github.com/smur89/alta-typst/stargazers"><img alt="Number of GitHub stargazers for altacv" src="https://img.shields.io/github/stars/smur89/alta-typst?style=flat-square"></a>
</p>

<p align="center">A two-column CV template for Typst, inspired by LianTze Lim's <a href="https://github.com/liantze/AltaCV">AltaCV</a> (LaTeX).<br>Write your CV once as <a href="https://jsonresume.org/">JSON Resume</a> data; pick a theme, a layout and a language.</p>

<!-- Relative path so the GIF tracks the codebase: GitHub renders the README from main, Universe from the package version's snapshot. examples/ ships in the typst/packages submission but is `exclude`d from the compiler bundle (see typst.toml). -->
<p align="center">
  <img alt="Animated preview: one CV in each built-in theme, each with a different layout" src="examples/preview.gif">
</p>
<p align="center"><sub>One CV in every built-in theme, each frame with a different layout: columns, portrait position and shape, header alignment, date format, QR code, justified text, single column, Irish labels, and show rules restyling the ratings and keywords.</sub></p>

## Highlights

- **Data, not layout.** Your CV is a [JSON Resume](https://jsonresume.org/schema/) dict, inline in Typst or loaded from a `resume.json`. Empty sections disappear, and a misspelt key or a wrong type stops the build with a message naming it.
- **Built-in themes**, every colour role overridable, plus theme tokens for the font, type scale, spacing and separators.
- **Any layout.** Two columns at any ratio, any section in either column, the side panel left or right, or a single column for applicant-tracking systems (ATS).
- **A rich header.** Portrait (circle, rounded or square; left, right or centred), contact bar with icons for common networks, and an optional QR code to your homepage for printed copies.
- **Ratings as dots.** Language fluency and skill levels from LinkedIn-style terms (`Native`, `Expert`) or exact numbers, in half-dot steps.
- **Every string translatable**, including month names and the document language; a [worked Irish translation](examples/labels-ga.toml) is included.
- **Print- and archive-ready.** PDF metadata comes from your data, and the output compiles as PDF/A and PDF/UA-1 (tagged, with alt text).

The full example, every section in use, over two pages ([source](https://github.com/smur89/alta-typst/blob/v1.8.0/examples/example-full.typ) <!-- x-release-please-version -->, [PDF](examples/example_full.pdf)):

| Page 1 | Page 2 |
| :---: | :---: |
| ![Alta CV page 1: header, experience, side-panel sections.](examples/example_full-1.png) | ![Alta CV page 2: publications grouped by type, interests, certificates, awards, references.](examples/example_full-2.png) |

## Contents

- [Quick start](#quick-start)
- [Customising](#customising): [themes](#themes-and-colours), [fonts](#fonts), [layout](#layout), [portrait and contacts](#portrait-contact-bar-and-qr-code), [translation](#translating-labels), [restyling](#restyling-parts), [PDF output](#pdf-metadata-pdfa-and-accessibility)
- [Reference](#reference): [data schema](#data-schema), [preferences](#preferences), [theme tokens](#theme-tokens), [labels](#labels), [part labels](#part-labels), [exports](#exports)
- [Contributing](#contributing) · [Credits](#credits) · [License](#license)

## Quick start

### Requirements

- **Typst 0.15.0** or later.
- **Fonts:** [Lato](https://fonts.google.com/specimen/Lato) (the default font) and the **FontAwesome 7 desktop** fonts (for icons). The Typst web app has both. Locally:

  ```bash
  # macOS (Homebrew)
  brew install --cask font-lato font-fontawesome
  ```

  Elsewhere, install Lato from Google Fonts and the FontAwesome 7 desktop OTFs from [fontawesome.com/download](https://fontawesome.com/download). Debian/Ubuntu's `fonts-font-awesome` is v6, which isn't read. Run `typst fonts` to check: without FontAwesome, icons render as empty boxes.

Package dependencies download automatically.

### Start a new CV

```bash
typst init @preview/altacv
```

This copies [`template/cv.typ`](template/cv.typ), a complete example CV, into a new project. Edit the data in place and compile.

### Render an existing `resume.json`

<!-- x-release-please-start-version -->
```typst
#import "@preview/altacv:1.8.0": alta-from-json

#alta-from-json(path("resume.json"))
```
<!-- x-release-please-end -->

The file is validated against the [JSON Resume schema](https://jsonresume.org/schema/) first, so a vanilla `resume.json` works without edits. Both routes take the same data: anything an inline dict can hold, altacv's [extensions](#extensions) included, a `resume.json` can too. Dates must be ISO 8601 (`2024`, `2024-06`, `2024-06-15`). To inspect or change the data before rendering, parse it yourself with `from-json-resume`:

<!-- x-release-please-start-version -->
```typst
#import "@preview/altacv:1.8.0": alta, from-json-resume, themes

#alta(from-json-resume(path("resume.json")), preferences: (theme: themes.forest))
```
<!-- x-release-please-end -->


### Write the data in Typst

<!-- x-release-please-start-version -->
```typst
#import "@preview/altacv:1.8.0": alta

#let cv = (
  basics: (
    name: "Jane Doe",
    label: "Senior Software Engineer",
    summary: [Backend engineer with eight years' experience…],
    email: "jane@example.com",
    phone: "+353 1 555 0100",
    location: "Dublin, Ireland",
    url: "https://janedoe.dev",
    profiles: (
      (network: "GitHub",   username: "janedoe", url: "https://github.com/janedoe"),
      (network: "LinkedIn", username: "janedoe", url: "https://linkedin.com/in/janedoe"),
    ),
  ),
  work: (
    (
      position: "Senior Software Engineer",
      name: "Acme Corp",
      url: "https://acme.example.com",  // links the company name
      location: "Dublin, Ireland",
      startDate: "2022-01",             // no endDate: "Present"
      highlights: ([Led the migration…], [Designed the platform…]),
      keywords: ("Python", "Go", "Rust"),
    ),
  ),
  skills: (
    (name: "Languages", level: "Expert", keywords: ("Scala", "Python")),
    (name: "Infra",     keywords: ("Kafka", "AWS", "Kubernetes")),
  ),
  languages: (
    (language: "English", fluency: "Native"),
    (language: "Irish",   fluency: "Professional Working"),
  ),
  // education, projects, publications, certificates, awards, …
)

#alta(cv)
```
<!-- x-release-please-end -->

Only `basics.name` is required. Fields that take "string or content" also accept Typst markup (`[Led the *platform* team]`); keep to plain strings if the data also lives in a `resume.json`, as JSON can't carry markup. The [data schema](#data-schema) lists every section and field.

## Customising

`alta()` takes the CV and two optional dicts, each merged over the defaults:

```typst
#alta(cv, labels: (:), preferences: (:))
```

Set only the keys you want to change. An unknown key or a wrong type panics with a message naming it. The full list is under [Preferences](#preferences) and [Labels](#labels). The snippets below assume the `cv` dict and import from [Quick start](#write-the-data-in-typst); the common settings:

<!-- x-release-please-start-version -->
```typst
#import "@preview/altacv:1.8.0": alta, maps-providers, themes

#alta(cv, preferences: (
  theme: themes.navy,
  paper: "us-letter",
  dateFormat: "short",              // 06/2024
  imagePosition: "left",
  linkContactInfo: (phone: false),  // everything linked but the phone
  mapsProvider: maps-providers.osm, // OpenStreetMap for basics.location
  rightColumnSections: ("focusAreas", "education", "skills", "languages", "certificates"),
))
```
<!-- x-release-please-end -->

Settings layer in order: the theme, then `preferences.colours` and `preferences.font`, then any [show rules](#restyling-parts), which win over both.

### Themes and colours

`preferences.theme` picks the look. The built-in themes are `themes.teal` (the default), `navy`, `crimson`, `forest`, `plum`, `charcoal`, `altacv`, `rust`, `bauhaus`, `riso`, `phosphor` and `catppuccin`.

`preferences.colours` then recolours any role over the theme's:

```typst
#alta(cv, preferences: (theme: themes.altacv, colours: (body: black)))
```

| Role | Colours |
|---|---|
| `accent` | Organisation names, tags, rating dots, contact icons, the objective's rule, publication titles, the QR code. |
| `emphasis` | Entry titles and interest group names. |
| `body` | Body text and icons. Dates, dividers and empty rating dots take lighter shades of it. |
| `heading` | Section titles. |
| `headingRule` | The rule under each section title. |
| `subheading` | Group titles, such as a publication type. |
| `name` | `basics.name`. |
| `tagline` | `basics.label`, under the name. |

Any `rgb(...)` value works; roles that colour text should stay dark enough to read on white.

A theme can also set the font, the type sizes and weights, the spacing and the separators. A theme of your own sets only what it changes; the rest comes from the default theme:

```typst
#alta(cv, preferences: (theme: (
  font: "Libertinus Serif",
  type: (headline: (size: 1.2)),  // section titles
  separator: (facts: " | "),
)))
```

To adjust a built-in theme, add to it: `themes.navy + (font: "Libertinus Serif")`. Typst's `+` merges only the top level, so `themes.navy + (colours: (accent: …))` replaces all of navy's colours; set a few roles with `preferences.colours` instead. Every token is listed under [Theme tokens](#theme-tokens).

### Fonts

`preferences.font` sets the font family (or a fallback array), over the theme's: `#alta(cv, preferences: (font: "Inter"))`. Any installed font works.

To set the name or headings in a different face, add a show rule before `#alta(...)`. The name is a level-1 heading and section titles are level 2; group and entry titles are deeper:

```typst
// A slab-serif name and section headings over a sans body:
#show heading.where(level: 1).or(heading.where(level: 2)): set text(font: "Roboto Slab")
#alta(cv, preferences: (font: "Source Sans 3"))
```

A plain `show heading: …` reaches group and entry titles too. A `set text(font: …)` outside `alta()` doesn't change the body: `alta()` sets the body's font, size, colour and language itself. Other text settings (tracking, number styles, OpenType features) still apply.

### Layout

`preferences.columnRatio` is the left column's share of the page width. `leftColumnSections` and `rightColumnSections` choose which sections go where, in order; by default long-form sections (experience, projects, publications) take the wide left column and the rest the right (see [Page and layout](#page-and-layout)). A section left out of both isn't rendered, even when it has data.

Invert the layout, side panel on the narrow left:

```typst
#alta(cv, preferences: (
  columnRatio: 0.35,
  leftColumnSections: ("focusAreas", "skills", "languages", "education", "certificates"),
  rightColumnSections: ("work", "publications"),
))
```

**Single column.** `columnRatio: 1` stacks every section in one full-width column, left list first, then right. Useful for applicant-tracking systems that misread multi-column PDFs:

```typst
#alta(cv, preferences: (
  columnRatio: 1,
  leftColumnSections: ("work", "education"),
  rightColumnSections: ("skills", "languages", "certificates"),
))
```

Page size and margins: `paper` (any [Typst paper name](https://typst.app/docs/reference/layout/page/#parameters-paper)) and `margin`. For a footer with your name and page numbers on multi-page CVs, set `pageFooter: auto`.

### Portrait, contact bar and QR code

**Portrait.** Set `basics.image` to add one. Pass it as a `path()`, which resolves relative to your own file, or as bytes:

```typst
basics: (
  image: path("avatar.png"),                 // recommended
  // image: read("avatar.png", encoding: none),
  // image: "/avatar.png",                   // relative to the --root dir
  // image: avatar-placeholder,              // built-in silhouette; import it from the package
  // …other basics fields
)
```

A bare relative string without the leading `/` resolves inside the package, so use `path()`. [JSON Resume](https://jsonresume.org/schema/) calls for a URL here, but Typst can't fetch remote files: keep the image next to your CV.

Position it with `imagePosition` (`"right"`, `"left"`, or `"center"` with `imageStackOrder` `"above"` / `"below"` the text), size it with `imageSize` and shape it with `imageShape` (`"circle"`, `"rounded"`, `"square"`). Non-square images are cropped from the centre. `headerTextAlign` aligns the name and contact bar.

**Contact bar.** Built from `basics.email`, `phone`, `location`, `url` and `profiles`, each linked (`mailto:`, `tel:`, a maps search, the URL). `linkContactInfo` turns linking off globally or per channel. For paper, turn linking off and set `printFullUrls: true` to print profile URLs in place of usernames.

**QR code.** For printed copies, `qrCode` adds a QR code to your homepage on the side opposite the portrait:

```typst
#alta(cv, preferences: (qrCode: auto))                         // encodes basics.url
#alta(cv, preferences: (qrCode: "https://janedoe.dev/cv"))     // any URL
```

### Translating labels

Every string the template prints is a label. Override any subset; the rest stay English:

```typst
#alta(cv, labels: (
  lang:         "de",
  work:         "Berufserfahrung",
  skills:       "Kenntnisse",
  education:    "Ausbildung",
  present:      "Heute",
  months: ("Jan", "Feb", "Mär", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"),
))
```

Set `lang` alongside any translation: it drives hyphenation, smart quotes and the PDF's language tag. For a full translation, copy [`internal/data/labels-en.toml`](internal/data/labels-en.toml) next to your CV (say as `labels-de.toml`), translate the values and load it:

```typst
#alta(cv, labels: toml("labels-de.toml"))
```

See [`examples/labels-ga.toml`](examples/labels-ga.toml) and [`examples/example-ga.typ`](https://github.com/smur89/alta-typst/blob/v1.8.0/examples/example-ga.typ) <!-- x-release-please-version --> for a complete Irish translation. Every key is under [Labels](#labels).

### Restyling parts

Parts of the CV carry Typst labels (`<alta-…>`) that show rules can target, to restyle one part without touching the rest. Put the rules before `#alta(...)`:

```typst
#show <alta-contact>: set text(font: "IBM Plex Mono")
#show <alta-date>: set text(style: "italic")
#show <alta-divider>: set line(stroke: (paint: gray))  // keeps the dash
#show <alta-rating-full>: [★]                          // stars for dots
#show <alta-rating-empty>: [☆]
#alta(cv)
```

A rule on a text part overrides the template's font, size, colour, weight, style or tracking for it, but not its icon (except a group title's, which follows the title's colour). The line parts take `set line(...)`. The marker parts (date and location icons, rating dots) can be recoloured or replaced; a replacement keeps the marker's place and alt text, and its glyph must be in one of your fonts. Rating dots also take `set circle(fill: …)`, and a glyph that replaces one takes its colour: the accent, or the border colour for an empty dot. A paragraph part, the line that lays out a row of items, takes `set par(…)`. Every part is listed under [Part labels](#part-labels), with its kind: the rules it takes, not the element it is. A replacement rule's `it` is the part as content, whatever builds it (text, a sequence, a `context`, an `align`), so use it whole (`tag(it)`, `emph(it)`), not `it.text`.

An entry's keywords (a project's stack, education's courses) are a line of text. To draw them as pills, replace each `<alta-keyword>` with a `tag()`, drop the separator between them, and space the `<alta-keywords>` line as skill rows are (0.8em, the default `keyword-row` gap) from its wrapped rows and the line above:

<!-- x-release-please-start-version -->
```typst
#import "@preview/altacv:1.8.0": alta, tag

#show <alta-keyword>: it => tag(it)
#show <alta-keywords>: set par(leading: 0.8em, spacing: 0.8em)
#alta(cv, preferences: (theme: (separator: (keywords: ""))))
```
<!-- x-release-please-end -->

The list bullet is Typst's `list`, so change it with a show-set rule: `#show list: set list(marker: [–])`. A plain `#set list(...)` doesn't reach inside `alta()`.

### PDF metadata, PDF/A and accessibility

The PDF's document properties are filled from your data:

| PDF field | Source |
|---|---|
| Title | `labels.documentTitle` (default `"{name} — CV"`) |
| Author | `basics.name` |
| Subject | `basics.summary` |
| Keywords | Every `skills[].keywords`, de-duplicated, then `meta.canonical` and `meta.version` |
| Date | `meta.lastModified` (ISO 8601), else the compile time |

```typst
meta: (
  lastModified: "2026-06-12",               // PDF date; footer with lastModifiedFooter: true
  canonical: "https://example.com/cv.json", // PDF Keywords
  version: "v1.0.0",                        // PDF Keywords; footer with footerVersion: true
)
```

For an archival (PDF/A) or accessible (PDF/UA-1) PDF, ask the compiler. The template needs no setting:

```sh
typst compile --pdf-standard a-2b,ua-1 cv.typ
```

The output has a tagged structure with nested headings, a document title, alt text for the portrait and meaningful icons, and the language from `labels.lang`.

## Reference

### Data schema

The `cv` dict follows [JSON Resume](https://jsonresume.org/schema/). Missing or empty sections are skipped, with no orphan headings. Spec fields altacv doesn't render (`basics.pronouns`, which JSON Resume [is removing](https://github.com/jsonresume/jsonresume.org/pull/629); a location's `address` and `postalCode`) are accepted and ignored, so a `resume.json` from elsewhere compiles unchanged.

#### Top-level keys

`basics`, `objective`, `work`, `volunteer`, `education`, `skills`, `languages`, `projects`, `publications`, `certificates`, `awards`, `interests`, `references`, `custom` ([extensions](#extensions)), `meta` ([PDF metadata](#pdf-metadata-pdfa-and-accessibility)), `$schema` (accepted, not rendered), and the deprecated `focusAreas`. Any other key panics, so a misspelt section (`publication`) fails rather than vanishing.

`objective` ([JSON Resume](https://jsonresume.org/schema/) 1.4.0) is a short career goal, a string or content, shown between the header and the first section, above the summary and set off like a pull quote.

#### Dates

ISO 8601 dates (`"2024"`, `"2024-06"`, `"2024-06-15"`) are formatted per `preferences.dateFormat`; other strings (`"Jan 2022"`) print as given. A missing or empty `endDate` reads `Present` (`labels.present`).

#### Extensions

altacv reads four optional fields the [JSON Resume schema](https://jsonresume.org/schema/) has no place for, from its own namespace in the schema's `custom` object. Other keys under `custom` are ignored.

```typst
(
  custom: (altacv: (focusAreas: ([Distributed systems], [Developer tooling]))),
  languages: ((language: "German", fluency: "Fluent", custom: (altacv: (rating: 3.5))),),
  skills: ((name: "Frontend", keywords: ("React",), custom: (altacv: (rating: 2.5))),),
  awards: ((title: "Best Paper", custom: (altacv: (url: "https://example.com/paper"))),),
)
```

| Field | Effect |
|---|---|
| `custom.altacv.focusAreas` (root) | An "Areas of Focus" section of prose bullets. Its section and label key is `focusAreas`. |
| `languages[].custom.altacv.rating` | An exact rating, 0 to `preferences.maxRating` in 0.5 steps; wins over `fluency`. |
| `skills[].custom.altacv.rating` | The same for a skill group; wins over `level`. |
| `awards[].custom.altacv.url` | Links the award title. |

**Deprecated:** the top-level `focusAreas`, `languages[].rating` and `awards[].url` are still read (`custom.altacv` wins when both are set) and are removed in the next major release ([#239](https://github.com/smur89/alta-typst/issues/239)).

#### `basics`

| Field | Effect |
|---|---|
| `name` | Required. The name, in uppercase unless `preferences.uppercaseName: false`. |
| `label` | The tagline under the name. |
| `summary` | The introduction under the header. |
| `image` | The portrait; see [Portrait](#portrait-contact-bar-and-qr-code). |
| `email`, `phone`, `url` | Contact bar entries. `url` shows without its scheme (`jane.dev`) and is what `qrCode: auto` encodes. |
| `location` | A string, or a dict `{address, postalCode, city, region, countryCode}`, shown as `city, region, countryCode`; the address and postcode aren't shown. |
| `profiles` | `{network, username, url}` entries in the contact bar, with the network's icon (see [Profile networks](#profile-networks)). |

#### Sections

Every entry section has the same layout: the title with its date at the right edge; the organisation and short facts with the location at the right edge; then the summary, highlights and keywords. Absent fields drop their line, and the title or organisation links to the entry's `url` when set.

These fields mean the same in every entry section:

| Field | Type | Meaning |
|---|---|---|
| `location` | string or dict | As in [`basics.location`](#basics). |
| `startDate` / `endDate` | string | A period, per [Dates](#dates); a single `date` is one date. |
| `summary` | string or content | A short paragraph of context. |
| `highlights` | array of content | A bulleted list of accomplishments. |
| `keywords`, `courses` | array of strings | One line at the end of the entry, joined with ` · `. Skills and interests show keywords their own way (below). |

**Deprecated:** `description` in `work`, `volunteer` and `projects` is read as `summary` (which wins); removed in the next major release ([#239](https://github.com/smur89/alta-typst/issues/239)).

| Section | Title | Facts line | Also reads |
|---|---|---|---|
| `work` | `position` | `name` (linked by `url`) | `location`, dates, `summary`, `highlights`, `keywords` |
| `volunteer` | `position` | `organization` (linked by `url`) | `location`, dates, `summary`, `highlights` |
| `education` | `studyType`, else `area` | `institution` (linked by `url`) | `location`, dates, `summary`, `courses`; a line above the courses with `area` (when `studyType` is the title) and `score` |
| `projects` | `name` (linked by `url`) | `entity · roles` | dates, `summary`, `highlights`, `keywords`, `type` |
| `certificates` | `name` (linked by `url`) | `issuer · credentialId` | `date`, `expiryDate` (makes the date a range), `summary` |
| `awards` | `title` (linked by `custom.altacv.url`) | `awarder` | `date`, `summary` |

An entry without its title field (`name` for projects and certificates, `title` for awards) is skipped.

**Projects** with a `type` are grouped under a subheading per type, each with its [project icon](#preferences); untyped projects pool under `labels.otherProjects` ("Other"). If no project has a type, the list is flat.

**Publications** render as a bibliography: the `name` (linked by `url`, else by the first DOI, arXiv or PMID identifier), then the `authors`, the source with its `releaseDate`, the identifiers and the `summary`.

| Field | Effect |
|---|---|
| `authors` | Author list. The CV owner's entry, matching `basics.name` or any of `preferences.ownerNames` (ignoring case), is set apart. |
| `publisher`, `volume`, `issue`, `pages` | The citation: `ACM 12(3), 45–67`. Hyphens in `pages` become an en dash. |
| `identifiers` | Persistent IDs keyed by scheme: `DOI 10.1000/182 · arXiv 2101.00001`. `doi`, `arxiv` and `pmid` are linked; others print as given. |
| `type` | Groups publications under a subheading per type, each with its icon. `article`, `book`, `patent`, `thesis` and `talk` have built-in headings (`labels.publicationTypes`); any other type is headed as written unless you add it there. Untyped entries are articles. Plural free-text types (`"Talks"`) still group with their code but are deprecated ([#239](https://github.com/smur89/alta-typst/issues/239)). |

**Skills** are `{name, level, keywords}` groups: the name as a label pill, then the keywords as pills. A `level` of `Beginner`, `Novice`, `Intermediate`, `Advanced`, `Expert` or `Master` (any case) shows as dots, scaled to `preferences.maxRating`; any other level shows as text. `preferences.skillLevelDisplay` forces `"rating"` (a level that doesn't map then panics) or `"text"`. Groups with no keywords are skipped.

**Languages** are `{language, fluency}`. LinkedIn's fluency terms (`Native`, `Bilingual`, `Full Professional`, `Professional Working`, `Limited Working`, `Elementary`, any case) show as dots; other strings show as text. An exact [rating extension](#extensions) wins. An entry with neither a rating nor `fluency` panics.

**Interests** are `{name, keywords}` lines: `Music: Trad, Jazz`. For prose bullets, use `focusAreas`.

**References** show the `reference` quote under the referee's `name`, with a line of `relationship`, `organization` and `date`. `availableOnRequest: true` prints `labels.referencesAvailableOnRequest` in place of the quote; if every entry sets it, the section is just that one line. Entries with neither a quote nor `availableOnRequest` are skipped.

#### Profile networks

`basics.profiles[].network` is matched, ignoring case, against: `Bluesky`, `GitHub`, `GitLab`, `Link`, `LinkedIn`, `Mastodon`, `Medium`, `ORCID`, `Stackoverflow`, `Twitter` (or `X`), `Website`. `Link` is a generic fallback. Any other network panics unless you give it an icon with `preferences.profileIcons`:

```typst
#alta(cv, preferences: (profileIcons: (kaggle: "kaggle", researchgate: "researchgate")))
```

Values are FontAwesome glyph names from [fontawesome.com/search](https://fontawesome.com/search); free brand and solid glyphs work, Pro ones need the Pro fonts.

### Preferences

#### Look

| Key | Default | Effect |
|---|---|---|
| `theme` | `themes.teal` | The theme: see [Themes and colours](#themes-and-colours). |
| `colours` | `(:)` | Colour roles over the theme's. |
| `font` | `auto` | Font family or fallback array, over the theme's (Lato by default). |
| `bodySize` | `10pt` | Base text size, an absolute length. Everything else scales from it. |
| `publicationIcons` | built-ins | Icon per `publications[].type`, from the [icon set](#exports); merged over the built-ins (`article` → `newspaper`, `book` and `thesis` → `book`, `talk` → `microphone`, others `file`). |
| `projectIcons` | `(:)` | Icon per `projects[].type` (e.g. `laptop-code`, `cubes`, `terminal`, `flask`); `folder` when unmapped. |
| `profileIcons` | built-ins | FontAwesome glyph per profile network; merged over the [built-ins](#profile-networks). |

#### Header

| Key | Default | Effect |
|---|---|---|
| `uppercaseName` | `true` | Set `false` for scripts without case, or where uppercasing changes letters (Turkish dotless i). |
| `headerTextAlign` | `"left"` | `"left"`, `"right"` or `"center"`. |
| `imageSize` | `6em` | The portrait's width and height. |
| `imageShape` | `"circle"` | `"circle"`, `"rounded"` or `"square"`. |
| `imagePosition` | `"right"` | `"left"`, `"right"`, or `"center"` (its own row). |
| `imageStackOrder` | `"above"` | With `"center"`: the portrait `"above"` or `"below"` the text. |
| `qrCode` | `none` | `auto` (encode `basics.url`; panics without one) or a URL string. |

#### Page and layout

| Key | Default | Effect |
|---|---|---|
| `paper` | `"a4"` | Any [Typst paper name](https://typst.app/docs/reference/layout/page/#parameters-paper). |
| `margin` | `(x: 0.9cm, y: 1.5cm)` | As `set page(margin: …)` takes. |
| `columnRatio` | `0.65` | The left column's share of the width, in `(0, 1]`; `1` for a single column. |
| `leftColumnSections` | `("work", "volunteer", "projects", "publications")` | Sections in the left column, in order. |
| `rightColumnSections` | `("focusAreas", "skills", "languages", "education", "certificates", "awards", "interests", "references")` | Sections in the right column, in order. |

#### Footer

| Key | Default | Effect |
|---|---|---|
| `pageFooter` | `none` | `auto`: on multi-page CVs, the name on the left and `labels.pageNumber` on the right. Or any content, on every page. Takes precedence over `lastModifiedFooter`. |
| `lastModifiedFooter` | `false` | Shows `labels.lastModified: meta.lastModified` in the footer. |
| `footerVersion` | `false` | Appends `(meta.version)` to that line. |

#### Formatting and links

| Key | Default | Effect |
|---|---|---|
| `justify` | `false` | Justify and hyphenate running text (summaries, highlights, quotes). |
| `dateFormat` | `"long"` | `"long"` (`Jun 2024`), `"short"` (`06/2024`), `"iso"` (unchanged), a [`datetime.display()`](https://typst.app/docs/reference/foundations/datetime/#definitions-display) pattern such as `"[day]/[month]/[year]"`, or a function `(year, month, day) => str`. |
| `linkContactInfo` | `true` | `false` to unlink the contact bar, or a dict keyed by `email`, `phone`, `location`, `url`, `profiles`. |
| `printFullUrls` | `false` | Unlinked profiles show their URL (`github.com/jane`) in place of the username. |
| `mapsProvider` | `maps-providers.google` | The location link: `maps-providers.{google,apple,bing,duckduckgo,osm}`, a template with `{q}`, or `none`. |
| `maxRating` | `5` | Dots per rating scale. |
| `skillLevelDisplay` | `auto` | `auto` (dots when the level maps, else text), `"rating"` (an unmapped level panics) or `"text"`. |
| `ownerNames` | `()` | Other spellings of your name among publication authors, e.g. `("J. Doe",)`. |

#### Deprecated

Still accepted; removed in the next major release ([#239](https://github.com/smur89/alta-typst/issues/239)).

| Key | Use instead |
|---|---|
| `accent` | `theme`, or `colours` for a custom colour. |
| `referencesAvailableOnRequest` | `references[].availableOnRequest`. |
| `groupCertificates`, `showPronouns` | Nothing: both are ignored. |

### Theme tokens

A theme dict may set any of these; unset tokens keep the default. A wrong key or type panics with its path (`theme.type.headline.size must be a number`).

| Key | Default | Sets |
|---|---|---|
| `font` | `"Lato"` | The font family, or a fallback array. |
| `colours` | the teal theme's | The [colour roles](#themes-and-colours). |
| `type` | `display` 2.5 bold, `headline` 1.4 bold, `title` 1.2 semibold, `body` regular | Each role's `size` (a multiple of `bodySize`) and `weight`: `display` the name, `headline` a section title, `title` an entry title or the tagline under the name, `body` the rest. |
| `font-weight` | `regular`, `bold` | The weights used for emphasis within a role. |
| `space` | `xx-small` 0.15, `x-small` 0.3, `small` 0.5, `medium` 0.8, `large` 1.2 | The spacing scale, in multiples of `bodySize`. |
| `stroke-width` | `thin` 0.5, `thick` 1 | Rule and border widths, in pt. |
| `leading` | 0.55 | Line spacing, in `em`. |
| `separator` | `facts` `" · "`, `items` `", "`, `label` `": "`, `range` `" – "`, `keywords` `" · "` | Between groups of facts, between items in a group, after a label (`Music: Trad`), between two dates, and between an entry's keywords. |
| `treatment` | `preamble` `"italic"`, `link` `"emph"`, `owner` `"strong"`, `label` `"strong"` | How a summary, a publication title, your name among authors and an interest's name stand out: `"italic"`, `"emph"`, `"strong"`, `"upper"` or `"none"`. |
| `citation` | `issue` `("(", ")")`, `pages` `", "`, `source` `" "`, `page-range` `"–"` | The punctuation of `ACM 12(3), 45–67`. |

### Labels

Defaults from [`internal/data/labels-en.toml`](internal/data/labels-en.toml). Section labels share the section's key.

| Key | Default |
|---|---|
| `lang` | `"en"`, an ISO 639 code (two or three lowercase letters) |
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
| `references` | `"References"` |
| `referencesAvailableOnRequest` | `"References available upon request."` |
| `otherProjects` | `"Other"`, the group for untyped projects |
| `present` | `"Present"` |
| `date`, `location` | `"Date"`, `"Location"`: read aloud by screen readers before an entry's date and location, not printed |
| `lastModified` | `"Last updated"` |
| `pageNumber` | `"Page {current} / {total}"` (`{total}` optional) |
| `documentTitle` | `"{name} — CV"`, the PDF title |
| `months` | `("Jan", "Feb", …, "Dec")`, exactly twelve |
| `publicationTypes` | `(article: "Articles", book: "Books", patent: "Patents", thesis: "Theses", talk: "Talks")`, merged entry by entry; other types print as given |
| `articles`, `publicationIcons` | Deprecated: use `publicationTypes.article` and `preferences.publicationIcons` ([#239](https://github.com/smur89/alta-typst/issues/239)) |

`pageNumber` and `documentTitle` are templates, so a translation can reorder them (`"Seite {current} von {total}"`). A missing required or unknown placeholder panics.

### Part labels

Show-rule targets for [restyling](#restyling-parts). They are public API and change only in a major release; labels prefixed `alta-internal-` may change at any time, so don't target them.

| Label | Kind | Part |
|---|---|---|
| `<alta-name>` | text | The name. |
| `<alta-headline>` | text | The tagline under the name (`basics.label`). |
| `<alta-section-title>` | text | A section's heading (Experience, Skills, …). |
| `<alta-entry-title>` | text | An entry's title: a role, qualification, project or award. |
| `<alta-group-title>` | text | A group's heading within a section: a publication type, a project type. |
| `<alta-contact>` | text | Each contact-bar entry. |
| `<alta-org>` | text | An entry's organisation: employer, institution, issuer or awarder. |
| `<alta-facts>` | text | The line under an entry's title: the organisation with its roles and details (`<alta-org>` sets the organisation's own colour). |
| `<alta-date>` | text | An entry's date or date range. |
| `<alta-location>` | text | An entry's location. |
| `<alta-summary>` | text | A summary: the CV's, the objective, or an entry's. |
| `<alta-pill>` | text | A skill pill's text (its box is the theme's). |
| `<alta-pill-label>` | text | A skill group's label pill. |
| `<alta-keyword>` | text | One of an entry's keywords: a work or project keyword, an education's course. |
| `<alta-keywords>` | paragraph | An entry's keyword line, a paragraph of its `<alta-keyword>` parts (not a skill or interest row). |
| `<alta-rating-label>` | text | A language's name beside its rating. |
| `<alta-footer>` | text | The page footer. |
| `<alta-section-rule>` | line | The line under a section's heading. |
| `<alta-divider>` | line | The dashed line between entries (and `divider()`). |
| `<alta-date-icon>`, `<alta-location-icon>` | marker | The icon before an entry's date or location (and in `term()`). |
| `<alta-rating-full>`, `<alta-rating-half>`, `<alta-rating-empty>` | marker | A filled, half-filled or empty rating dot. |

### Exports

Everything the package exports. The building blocks from `icon` to `styled-link` are what `alta()` draws with; import them to compose a section of your own. Each export has a doc comment, shown on hover in Tinymist and other Typst editors.

| Export | Purpose |
|---|---|
| `alta(cv, labels:, preferences:)` | Renders the CV. |
| `alta-from-json(data, ..)` | Validates and renders a `resume.json`. |
| `from-json-resume(data)` | Validates and parses a `resume.json` into a `cv` dict. |
| `themes` | The built-in themes. |
| `maps-providers` | Map link templates for `mapsProvider`. |
| `avatar-placeholder` | A generic silhouette for `basics.image`. |
| `icon(name, ..)` | A glyph from the built-in icon set: `book`, `calendar`, `cubes`, `email`, `file`, `flask`, `folder`, `laptop-code`, `location`, `microphone`, `newspaper`, `phone`, `terminal` and the profile networks. |
| `name(body)` | An accent-coloured organisation line. |
| `term(period, location: none)` | A date and optional location, each with its icon. |
| `rating(label, value, max: auto)` | A label with rating dots. |
| `tag(body, ..)` | A pill. |
| `divider()` | The dashed rule between entries. |
| `styled-link(content, dest: none)` | Text in the entry-title style, linked when `dest` is set. |
| `palettes` | Deprecated: the heading colours of the original six themes, `teal` to `charcoal`. Use `themes`. |

<!-- x-release-please-start-version -->
```typst
#import "@preview/altacv:1.8.0": alta, tag, divider, themes
```
<!-- x-release-please-end -->

## Contributing

Bug reports and pull requests are welcome; see [CONTRIBUTING.md](CONTRIBUTING.md).

## Credits

- **[LianTze Lim — AltaCV](https://github.com/liantze/AltaCV)** (LPPL). The visual ancestor: the two-column layout, accent palette, and section structure originate in LianTze's LaTeX class.
- **[Catppuccin](https://github.com/catppuccin/catppuccin)** (MIT). `themes.catppuccin` uses the Latte flavour's colours.
- **[George Honeywood — alta-typst](https://github.com/GeorgeHoneywood/alta-typst)** (MIT, © 2023). Prior Typst implementation; the grid layout, pill tags, and half-fill skill dots originate there.

## License

[MIT](LICENSE). Copyright © 2023 George Honeywood, © 2026 Shane Murphy.
