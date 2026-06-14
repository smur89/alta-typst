// Default labels and preferences. Both dicts shallow-merge with user
// overrides through `_strict_merge` (`internal/validation.typ`), so
// unknown keys panic.
//
// `_default_preferences` derives its column section lists from
// `_sections` in `layout.typ`, so adding a section there automatically
// places it in the default layout under its declared column.

#import "state.typ": palettes, maps-providers
#import "layout.typ": _sections

// Label keys mirror JSON Resume's section keys (`work`, `certificates`,
// …) so callers think in a single vocabulary. The values are editorial:
// "Experience" reads better than "Work" as a CV heading,
// "Certifications" than "Certificates".
#let _default_labels = (
  work: "Experience",
  volunteer: "Volunteer",
  focusAreas: "Areas of Focus",
  skills: "Skills",
  languages: "Languages",
  education: "Education",
  certificates: "Certifications",
  publications: "Publications",
  awards: "Awards",
  projects: "Projects",
  interests: "Interests",
  articles: "Articles",
  present: "Present",
  lastModified: "Last updated",
  // Twelve abbreviated month names, January–December. Used by the
  // built-in `dateFormat: "long"` formatter to render ISO 8601 inputs
  // (e.g. "2024-06" → "Jun 2024"). Override to localise; the array
  // must keep length 12 (validated in alta()).
  months: ("Jan", "Feb", "Mar", "Apr", "May", "Jun",
           "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
  // Per-`publications[].type` icon overrides. Keys match the `type`
  // string (case-insensitive); values are utility-icon names. The
  // module ships sensible defaults for `Articles`, `Books`, `Talks`,
  // `Conference Papers`, etc. — see `_default_publication_icons` in
  // `sections/publications.typ` — and falls back to `file` for
  // unknown types. Override here to add custom types or remap
  // built-ins.
  publicationIcons: (:),
)

// Defaults derived from `_sections` so adding a section there
// automatically places it in the default layout for its declared
// column. Insertion order in `_sections` controls render order.
#let _keys_for_column(col) = _sections.keys().filter(k => _sections.at(k).column == col)

// User-facing reference for these prefs lives in the README. Comments
// below capture only what isn't recoverable from the key name + default
// — non-obvious constraints, footguns, and design rationale.
#let _default_preferences = (
  // Must be installed on the build host (CI installs Lato).
  font: "Lato",
  // Every spacing token is an em-multiplier of this, so changing one
  // knob scales the whole document proportionally.
  bodySize: 10pt,
  paper: "a4",
  margin: (x: 0.9cm, y: 1.5cm),
  // `palettes.teal` — see the `palettes` dict for the curated set
  // (`teal`, `navy`, `crimson`, `forest`, `plum`, `charcoal`).
  accent: palettes.teal,
  groupCertificates: true,
  imageSize: 6em,
  linkContactInfo: true,
  // `{q}` is substituted with the URL-encoded location. A string
  // missing that placeholder panics so a typo is caught up front
  // rather than producing a dead link.
  mapsProvider: maps-providers.google,
  imagePosition: "right",
  // Only consulted when `imagePosition` is "center" — chooses whether
  // the centred portrait stacks above or below the header text block.
  imageStackOrder: "above",
  headerTextAlign: "left",
  // PDF metadata (title / author) stays as-supplied regardless of
  // this flag — see the comment above `set document(...)`.
  uppercaseName: true,
  // When true and `cv.meta.lastModified` is set, render a small
  // "Last updated: <value>" line in the page footer. PDF metadata
  // (date / keywords / description) is populated from `meta` and
  // `basics` independently of this flag.
  lastModifiedFooter: false,
  // Controls how ISO 8601 date strings ("2024", "2024-06", "2024-06-15")
  // are rendered wherever the template surfaces a date. Non-ISO strings
  // (e.g. "Jan 2022", "May 2016 – Jul 2017") pass through verbatim
  // regardless of this setting, so pre-formatted data keeps working.
  //   "long"  — "Jun 2024" / "15 Jun 2024" (month names from labels.months)
  //   "short" — "06/2024"  / "15/06/2024"
  //   "iso"   — passthrough of the original string
  //   closure — (parts) -> str, where parts is (year, month?, day?)
  dateFormat: "long",
  // Fraction in (0, 1] (validated in alta()). Use the complement
  // (`1 - r`) and swap the column-section arrays to invert the layout;
  // exactly 1 collapses the grid to a single full-width column.
  columnRatio: 0.65,
  // `none` (default) — no footer. `"auto"` — name + "Page N / M" on
  // multi-page documents only (single-page stays clean). Any content
  // value — rendered verbatim as the footer on every page.
  pageFooter: none,
  // Sections omitted from BOTH arrays don't render even if their data
  // is present; sections listed in both render twice. Defaults derive
  // from `_sections` so adding a section there places it automatically.
  leftColumnSections: _keys_for_column("left"),
  rightColumnSections: _keys_for_column("right"),
  // Number of dots on the language fluency scale. Default 5 matches
  // LinkedIn's scale (and the built-in `fluency` string map). Override
  // to suit other scales — CEFR (6: A1–C2), ILR (5), or custom.
  // Fluency strings remain anchored to LinkedIn's 0–5 scale, so callers
  // using a non-5 maxRating must supply numeric `rating` values.
  maxRating: 5,
)
