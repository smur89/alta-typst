// `altacv`, `alta()` and `alta-from-json()`, re-exported from `lib.typ`: the
// render pipeline ARCHITECTURE.md describes. Not in `lib.typ`, which
// would then re-export every helper this imports.

#import "util/dates.typ": _format-date
#import "data/options.typ": (
  _check-template-preferences, _checked-theme, _merge-options,
)
#import "data/read.typ": _read-cv
#import "data/metadata.typ": _pdf-metadata
#import "data/json-resume.typ": from-json-resume
#import "data/defaults.typ": _default-preferences
#import "data/cv.typ": _owner-keys
#import "design/presets.typ": themes
#import "design/styles.typ": _justify, _level-headings
#import "design/theme.typ": _theme-for
#import "context.typ": _max-rating-state
#import "document.typ": _document, _standalone
#import "registry.typ": _renderers
#import "components/columns.typ": _columns
#import "../sections/header.typ": _header
#import "../sections/intro.typ": _intro
#import "footers.typ": _cv-details
#import "../sections/footer.typ": _footer
#import "../adapter/json-resume.typ": _resume

// The merged options, the read CV and the `ctx` every renderer takes
// with its data, in `context`: the labels follow `text.lang`.
// `format-date` formats a date per the preferences and labels; `owner`
// is the CV owner's name, and `owners` every spelling of it
// (`preferences.owner-names` too), trimmed and lowercased, to bold among
// publication authors. `details` is what a footer prints of the CV
// (`footers.typ`), for the `<alta-cv>` marker and the
// standalone footer alike. `json-resume` is the checked, canonical CV
// in JSON Resume's camelCase, for the template's mapping.
#let _prepare(cv, labels, preferences) = {
  let (labels, prefs) = _merge-options(labels, preferences, lang: text.lang)
  let (cv, sections, json-resume) = _read-cv(cv, prefs)
  let ctx = (
    labels: labels,
    prefs: prefs,
    format-date: v => _format-date(v, prefs.date-format, labels.months),
    owner: cv.basics.name,
    owners: _owner-keys((cv.basics.name, ..prefs.owner-names)),
  )
  (
    cv: cv,
    sections: sections,
    json-resume: json-resume,
    ctx: ctx,
    details: _cv-details(cv, labels),
  )
}

// What `alta()` leaves for the content after it, in both forms: the
// public `rating()`'s scale, and what the footer helpers print.
#let _cv-marks(prefs, details) = {
  _max-rating-state.update(prefs.max-rating)
  [#metadata(details)<alta-cv>]
}

// The CV itself, from `_prepare`, as standalone `alta()` draws it with
// the section renderers.
#let _cv-content((cv, sections, ctx, details)) = {
  _cv-marks(ctx.prefs, details)
  show: _justify.with(ctx.prefs.justify)
  _header(cv, ctx)
  _intro(cv, ctx)
  // Renderers are width-agnostic, so any section fits either column.
  let render(key) = (_renderers.at(key))(sections.at(key), ctx)
  _columns(
    ctx.prefs.left-column-sections.map(render),
    ctx.prefs.right-column-sections.map(render),
    ctx.prefs.column-ratio,
  )
}

// `alta()` inside the template, rendered by `altacv`'s show rule: only
// the CV, drawn by the JSON Resume mapping (`adapter/json-resume.typ`)
// from the public blocks, so what it draws is what a user's copy of
// the mapping draws. At the next major (#239) `alta()` returns this
// directly.
#let _alta-content(cv, labels: (:), preferences: (:)) = context {
  _check-template-preferences(labels, preferences)
  let (cv, sections, json-resume, ctx, details) = _prepare(
    cv,
    labels,
    preferences,
  )
  // For `altacv` to set at the top level: `set document` fails inside a
  // container, where this may sit (`#block(alta(cv))`).
  [#metadata(_pdf-metadata(cv, sections, ctx.labels))<alta-internal-document>]
  // The mapping justifies its own prose.
  _cv-marks(ctx.prefs, details)
  _resume(json-resume, ctx.labels, ctx.prefs)
}

// `alta()` on its own (removed in the next major, #239): the template's
// body and the preferences that stand in for the set rules after it,
// the footer among them, around the CV.
#let _alta-standalone(cv, labels: (:), preferences: (:)) = context {
  let prepared = _prepare(cv, labels, preferences)
  let (cv, sections, ctx, details) = prepared
  set document(.._pdf-metadata(cv, sections, ctx.labels))
  show: _standalone.with(ctx.prefs, ctx.labels, _footer(details, ctx.prefs))
  // Standalone keeps today's levels: the sections one below the name.
  set heading(offset: 1)
  _cv-content(prepared)
}

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
  let built = _theme-for(_checked-theme(theme), (:))
  show: _document.with(
    built,
    _default-preferences.body-size,
    _default-preferences.margin,
  )
  show: _level-headings.with(built)
  // The mapping's intro, spaced as `alta()`'s: a paragraph's spacing,
  // which merges with its neighbours', and the theme's `intro` inside
  // it, which adds to it; a later `show <alta-intro>: set block(..)`
  // wins.
  show <alta-intro>: set block(
    spacing: built.par.spacing,
    inset: (top: built.intro.above * 1em, bottom: built.intro.below * 1em),
  )
  // Picks `alta()`'s template form: the CV alone, from its metadata.
  show <alta-internal-standalone>: none
  show <alta-internal-cv>: it => _alta-content(
    it.value.cv,
    labels: it.value.labels,
    preferences: it.value.preferences,
  )
  // The first CV's PDF metadata (`_alta-content`): a `set document` in
  // a top-level `context` reaches the document, and one of the user's
  // own in `body` still wins.
  context {
    let info = query(<alta-internal-document>).at(0, default: none)
    if info != none { set document(..info.value) }
  }
  body
}

/// Renders a CV from a JSON Resume-style dictionary. On its own it
/// applies the template itself. Inside `#show: altacv.with(..)` it emits
/// only the CV, and document-level preferences (theme, colours, font,
/// sizes, paper, margin, footers) panic, naming the template argument or
/// set rule that replaces each. Every input is checked before anything
/// renders. The labels follow the document's language:
/// `#set text(lang: "ga")` before `alta()` renders them in Irish.
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
) = {
  // Both forms; `altacv`'s show rules pick one. Through the style chain
  // rather than state, so the choice holds on the first layout pass
  // (standalone's `set page` would fail inside a container) and ends
  // where the template's scope does. Without the template the metadata
  // renders nothing.
  [#_alta-standalone(
    cv,
    labels: labels,
    preferences: preferences,
  )<alta-internal-standalone>]
  [#metadata((
    cv: cv,
    labels: labels,
    preferences: preferences,
  ))<alta-internal-cv>]
}

// `..rest` forwards future `alta` kwargs without an edit here. Extra
// positionals (`alta-from-json(p, my-prefs)`) panic with a
// wrapper-aware message rather than an `alta`-level one.
/// Renders a CV from a `resume.json`, validated against the JSON Resume
/// schema first: `alta(from-json-resume(data), ..)`.
///
/// - data (path, dictionary): The `resume.json`, as for
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
