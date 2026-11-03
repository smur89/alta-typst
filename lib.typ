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
#import "internal/data/options.typ": _merge-options
#import "internal/data/read.typ": _read-cv
#import "internal/data/metadata.typ": _pdf-metadata
#import "internal/data/json-resume.typ": from-json-resume
#import "internal/document.typ": _document
#import "internal/registry.typ": _renderers
#import "internal/components/columns.typ": _columns
#import "sections/header.typ": _header
#import "sections/intro.typ": _intro
#import "sections/footer.typ": _resolve-page-footer

// Generic silhouette, exposed as bytes so the `typst init` template
// (and any consumer) gets a working `basics.image` without its own SVG.
#let avatar-placeholder = read("assets/avatar-placeholder.svg", encoding: none)

// `cv` follows the JSON Resume schema; `labels` and `preferences` are
// partial dicts merged over the defaults (unknown keys panic). Every
// input is checked before anything renders.
#let alta(
  cv,
  labels: (:),
  preferences: (:),
) = {
  let (labels, preferences) = _merge-options(labels, preferences)
  let (cv, sections) = _read-cv(cv, preferences)
  let name = cv.basics.name
  set document(.._pdf-metadata(cv, sections, labels))
  show: _document.with(
    preferences,
    labels,
    footer: _resolve-page-footer(preferences, labels, cv.meta, name),
  )

  _header(cv, preferences)
  _intro(cv)
  // Renderers are width-agnostic, so any section fits either column.
  // `owner` bolds the CV owner among publication authors.
  let ctx = (labels: labels, prefs: preferences, owner: name)
  let render(key) = (_renderers.at(key))(sections.at(key), ctx)
  _columns(
    preferences.leftColumnSections.map(render),
    preferences.rightColumnSections.map(render),
    preferences.columnRatio,
  )
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
