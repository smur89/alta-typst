// altacv — a two-column CV template for Typst. Visually descended from
// LianTze Lim's AltaCV LaTeX class (https://github.com/liantze/AltaCV,
// LPPL); forked from George Honeywood's alta-typst
// (https://github.com/GeorgeHoneywood/alta-typst, MIT, © 2023 George
// Honeywood) and rewritten around a JSON Resume-style data dict.
//
// Public entry: `alta(cv, ...)` plus the helpers in the README.
// `sections/` has one renderer per CV part, mapping it onto
// `internal/components/`; the column sections are bound in
// `internal/registry.typ`. `internal/data/` reads and checks the CV,
// labels and preferences, `internal/design/` holds the theme, and
// `internal/util/` the generic helpers.
//
// Every colour, size and gap, and the sizing rule they follow, live
// in `internal/design/theme.typ`.

// Public API, re-exported: the presets and the helpers for custom
// layouts (see the README's Helpers section).
#import "internal/data/defaults.typ": maps-providers
#import "internal/design/presets.typ": palettes
#import "internal/primitives.typ": divider, name, styled-link, tag, term
#import "internal/icons.typ": icon
#import "internal/components/ratings.typ": rating
#import "internal/context.typ": (
  _accent_state, _body_size_state, _max_rating_state,
)
#import "internal/design/theme.typ": _theme
#import "internal/design/styles.typ": _content_styles
#import "internal/data/canonical.typ": _canonical_cv
#import "internal/util/checks.typ": _check_unknown_keys
#import "internal/util/fields.typ": _field, _string_at
#import "internal/util/values.typ": _fill_template
#import "internal/util/dates.typ": _iso_datetime
#import "sections/header.typ": _header
#import "sections/intro.typ": _intro
#import "sections/footer.typ": _resolve_page_footer
#import "internal/data/sections.typ": _cv_keys, _read_sections
#import "internal/registry.typ": _renderers
#import "internal/data/options.typ": _merge_options
#import "internal/data/json-resume.typ": from-json-resume

// Generic silhouette, exposed as bytes so the `typst init` template
// (and any consumer) gets a working `basics.image` without its own SVG.
#let avatar-placeholder = read("assets/avatar-placeholder.svg", encoding: none)

// Skill keywords for the PDF `Keywords` field, first occurrence first.
#let _collect_keywords(skills) = (
  skills
    .map(group => group.at("keywords", default: ()))
    .sum(default: ())
    .filter(kw => type(kw) == str and kw != "")
    .dedup()
)

// `cv` follows the JSON Resume schema; `labels` and `preferences` are
// partial dicts merged over the defaults (unknown keys panic).
#let alta(
  cv,
  labels: (:),
  preferences: (:),
) = {
  // `basics.name` is the only required field; a guided panic beats a
  // bare missing-key error.
  if type(cv) != dictionary {
    panic("alta() expects a CV data dictionary, got: " + repr(cv))
  }
  let basics = cv.at("basics", default: none)
  if (
    type(basics) != dictionary or _field(basics, "name") == none
  ) {
    panic(
      "cv.basics.name is required (a non-empty string) — every other "
        + "field is optional. Got basics: "
        + repr(basics),
    )
  }
  // A misspelt section (`publication:`) would otherwise vanish silently.
  _check_unknown_keys(cv.keys(), _cv_keys, "CV top-level")
  let (labels, preferences) = _merge_options(labels, preferences)
  let cv = _canonical_cv(cv, preferences)
  // Before the PDF keywords below walk `skills`.
  let section-data = _read_sections(cv)
  let column-ratio = preferences.columnRatio
  let max-rating = preferences.maxRating
  let accent = preferences.accent
  let body-size = preferences.bodySize
  _accent_state.update(accent)
  _body_size_state.update(body-size)
  _max_rating_state.update(max-rating)

  // Optional metadata is set only when non-empty: `set document(...)`
  // rejects a `none` date, and empty strings would still write an entry.
  let meta = cv.at("meta", default: (:))
  let last-modified-raw = meta.at("lastModified", default: none)
  let canonical = _string_at(meta, "canonical")
  let version = _string_at(meta, "version")
  let doc-date = _iso_datetime(last-modified-raw)
  // `set document(...)` has no URL or version field, so
  // `meta.canonical` / `meta.version` ride the Keywords — the only
  // machine-readable home. `_string_at` because Keywords must be
  // strings and a dict passed to `alta()` directly is unvalidated.
  let doc-keywords = _collect_keywords(section-data.skills)
  if canonical != none { doc-keywords.push(canonical) }
  if version != none { doc-keywords.push(version) }
  let doc-description = _field(cv.basics, "summary")
  set document(
    // `uppercaseName` is purely visual — PDF metadata stays canonical.
    title: _fill_template(labels.documentTitle, (name: cv.basics.name)),
    author: cv.basics.name,
    ..(if doc-keywords.len() > 0 { (keywords: doc-keywords) }),
    ..(if doc-description != none { (description: doc-description) }),
    ..(if doc-date != none { (date: doc-date) }),
  )
  set text(
    body-size,
    font: preferences.font,
    fill: _theme.colour.body,
    lang: labels.lang,
  )
  set page(
    paper: preferences.paper,
    margin: preferences.margin,
    footer: _resolve_page_footer(preferences, labels, meta, cv.basics.name),
  )
  show: _content_styles.with(body-size, accent)

  _header(cv, preferences)
  _intro(cv)

  // Renderers are width-agnostic, so any section fits either column.
  // `owner` bolds the CV owner among publication authors.
  let ctx = (labels: labels, prefs: preferences, owner: cv.basics.name)
  let render-column(keys) = {
    for key in keys {
      (_renderers.at(key))(section-data.at(key), ctx)
    }
  }

  // The fr columns split what the gutter leaves, so both sides give up
  // a proportional share of it.
  if column-ratio == 1 {
    render-column(
      preferences.leftColumnSections + preferences.rightColumnSections,
    )
  } else if preferences.rightColumnSections.len() == 0 {
    render-column(preferences.leftColumnSections)
  } else {
    grid(
      columns: (column-ratio * 1fr, (1 - column-ratio) * 1fr),
      column-gutter: _theme.column-gutter,
      render-column(preferences.leftColumnSections),
      render-column(preferences.rightColumnSections),
    )
  }
}

// `..rest` forwards future `alta` kwargs without an edit here. Extra
// positionals (`alta-from-json(p, my-prefs)`) panic with a
// wrapper-aware message rather than an `alta`-level one.
#let alta-from-json(data, ..rest) = {
  if rest.pos().len() > 0 {
    panic(
      "alta-from-json takes one positional (`data`); pass labels/preferences as named arguments. Got extra positionals: "
        + repr(rest.pos()),
    )
  }
  alta(from-json-resume(data), ..rest)
}
