// `alta()` and `alta-from-json()`, re-exported from `lib.typ`: the
// render pipeline ARCHITECTURE.md describes. Not in `lib.typ`, which
// would then re-export every helper this imports.

#import "util/dates.typ": _format-date
#import "data/options.typ": _merge-options
#import "data/read.typ": _read-cv
#import "data/metadata.typ": _pdf-metadata
#import "data/json-resume.typ": from-json-resume
#import "document.typ": _document
#import "registry.typ": _renderers
#import "components/columns.typ": _columns
#import "../sections/header.typ": _header
#import "../sections/intro.typ": _intro
#import "../sections/footer.typ": _footer

/// Renders a CV from a JSON Resume-style dictionary. Every input is
/// checked before anything renders. The labels follow the document's
/// language: `#set text(lang: "ga")` before `alta()` renders them in
/// Irish.
///
/// - cv (dictionary): The CV, in the JSON Resume schema plus altacv's
///   `custom.altacv` extensions. Unknown keys and wrong types panic,
///   naming the field.
/// - labels (dictionary): Display strings to override, merged over the
///   defaults for the document's language (`text.lang`). See the
///   README's Labels section.
/// - preferences (dictionary): Settings to override (colours, font,
///   columns, …), merged over the defaults. See the README's
///   Preferences tables.
/// -> content
#let alta(
  cv,
  labels: (:),
  preferences: (:),
) = context {
  let (labels, prefs) = _merge-options(labels, preferences, lang: text.lang)
  let (cv, sections) = _read-cv(cv, prefs)
  // What every renderer takes with its data. `format-date` formats a
  // date per the preferences and labels; `owner` is the CV owner's
  // name, and `owners` every spelling of it (`preferences.ownerNames`
  // too), trimmed and lowercased, to bold among publication authors.
  let ctx = (
    labels: labels,
    prefs: prefs,
    format-date: v => _format-date(v, prefs.dateFormat, labels.months),
    owner: cv.basics.name,
    owners: (cv.basics.name, ..prefs.ownerNames).map(n => lower(n.trim())),
  )
  set document(.._pdf-metadata(cv, sections, labels))
  show: _document.with(prefs, labels, footer: _footer(cv, ctx))

  _header(cv, ctx)
  _intro(cv, ctx)
  // Renderers are width-agnostic, so any section fits either column.
  let render(key) = (_renderers.at(key))(sections.at(key), ctx)
  _columns(
    prefs.leftColumnSections.map(render),
    prefs.rightColumnSections.map(render),
    prefs.columnRatio,
  )
}

// `..rest` forwards future `alta` kwargs without an edit here. Extra
// positionals (`alta-from-json(p, my-prefs)`) panic with a
// wrapper-aware message rather than an `alta`-level one.
/// Renders a CV from a `resume.json`, validated against the JSON Resume
/// schema first: `alta(from-json-resume(data), ..)`.
///
/// - data (path, str, dictionary): The `resume.json`, as for
///   `from-json-resume`.
/// - ..rest (arguments): `labels:` and `preferences:`, as for `alta`.
/// -> content
#let alta-from-json(data, ..rest) = {
  if rest.pos().len() > 0 {
    panic(
      "alta-from-json takes one positional (`data`); pass labels/preferences as named arguments. Got extra positionals: "
        + repr(rest.pos()),
    )
  }
  alta(from-json-resume(data), ..rest)
}
