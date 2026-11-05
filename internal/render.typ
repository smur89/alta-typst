// `altacv`, `alta()` and `alta-from-json()`, re-exported from `lib.typ`: the
// render pipeline ARCHITECTURE.md describes. Not in `lib.typ`, which
// would then re-export every helper this imports.

#import "util/dates.typ": _format-date
#import "data/options.typ": _check-template-preferences, _merge-options
#import "data/read.typ": _read-cv
#import "data/metadata.typ": _pdf-metadata
#import "data/json-resume.typ": from-json-resume
#import "data/defaults.typ": _default-preferences
#import "design/presets.typ": themes
#import "design/styles.typ": _justify
#import "design/theme.typ": _theme-for
#import "context.typ": _max-rating-state, _template-state
#import "document.typ": _document, _standalone
#import "registry.typ": _renderers
#import "components/columns.typ": _columns
#import "../sections/header.typ": _header
#import "../sections/intro.typ": _intro
#import "../sections/footer.typ": _cv-details, _footer

/// The altacv template: `#show: altacv.with(theme: themes.navy)`, then
/// `#alta(cv)` and any other content. It sets the theme, the default
/// text and margins, and the heading and list rules; your own `set`
/// and `show` rules after it win (`set page(paper: ..)`,
/// `set text(lang: ..)`, `show heading: ..`).
///
/// - theme (dictionary): A built-in theme (`themes.teal`, …) or theme
///   tokens over it. See the README's Theme tokens.
/// - body (content): The document.
/// -> content
#let altacv(theme: themes.teal, body) = {
  // Checked and canonicalised as `preferences.theme` is.
  let theme = _merge-options((:), (theme: theme)).prefs.theme
  _template-state.update(true)
  show: _document.with(_theme-for(theme, (:)), _default-preferences.margin)
  body
}

/// Renders a CV from a JSON Resume-style dictionary. Inside
/// `#show: altacv.with(..)` it emits only the CV; on its own it applies
/// the template itself. Every input
/// is checked before anything renders. The labels follow the document's
/// language: `#set text(lang: "ga")` before `alta()` renders them in
/// Irish.
///
/// Inside the template, document-level preferences (theme, colours, font,
/// sizes, paper, margin, footers) panic, naming the template argument or
/// set rule that replaces each.
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
  let in-template = _template-state.get()
  if in-template { _check-template-preferences(preferences) }
  let (labels, prefs) = _merge-options(labels, preferences, lang: text.lang)
  let (cv, sections) = _read-cv(cv, prefs)
  // What every renderer takes with its data. `format-date` formats a
  // date per the preferences and labels; `owner` is the CV owner's
  // name, and `owners` every spelling of it (`preferences.owner-names`
  // too), trimmed and lowercased, to bold among publication authors.
  let ctx = (
    labels: labels,
    prefs: prefs,
    format-date: v => _format-date(v, prefs.date-format, labels.months),
    owner: cv.basics.name,
    owners: (cv.basics.name, ..prefs.owner-names).map(n => lower(n.trim())),
  )
  let content = {
    _max-rating-state.update(prefs.max-rating)
    // What the footer helpers print (`sections/footer.typ`).
    [#metadata(_cv-details(cv, labels))<alta-cv>]
    set document(.._pdf-metadata(cv, sections, labels))
    show: _justify.with(prefs.justify)
    _header(cv, ctx)
    _intro(cv, ctx)
    // Renderers are width-agnostic, so any section fits either column.
    let render(key) = (_renderers.at(key))(sections.at(key), ctx)
    _columns(
      prefs.left-column-sections.map(render),
      prefs.right-column-sections.map(render),
      prefs.column-ratio,
    )
  }
  if in-template { content } else {
    // Standalone (removed in the next major, #239): the template's body
    // and the preferences that stand in for set rules after it. Not
    // `altacv` itself: its `_template-state` update would sit inside
    // this context, which reads the state, so it would never converge.
    show: _standalone.with(prefs, labels, _footer(cv, ctx))
    content
  }
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
