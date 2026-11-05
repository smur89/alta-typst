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
#import "design/presets.typ": themes
#import "design/styles.typ": _justify
#import "design/theme.typ": _theme-for
#import "context.typ": _max-rating-state
#import "document.typ": _document, _standalone
#import "registry.typ": _renderers
#import "components/columns.typ": _columns
#import "../sections/header.typ": _header
#import "../sections/intro.typ": _intro
#import "../sections/footer.typ": _cv-details, _footer

// The merged options, the read CV and the `ctx` every renderer takes
// with its data, in `context`: the labels follow `text.lang`.
// `format-date` formats a date per the preferences and labels; `owner`
// is the CV owner's name, and `owners` every spelling of it
// (`preferences.owner-names` too), trimmed and lowercased, to bold among
// publication authors.
#let _prepare(cv, labels, preferences) = {
  let (labels, prefs) = _merge-options(labels, preferences, lang: text.lang)
  let (cv, sections) = _read-cv(cv, prefs)
  let ctx = (
    labels: labels,
    prefs: prefs,
    format-date: v => _format-date(v, prefs.date-format, labels.months),
    owner: cv.basics.name,
    owners: (cv.basics.name, ..prefs.owner-names).map(n => lower(n.trim())),
  )
  (cv: cv, sections: sections, ctx: ctx)
}

// The CV itself, from `_prepare`, in both of `alta()`'s forms.
#let _cv-content((cv, sections, ctx)) = {
  _max-rating-state.update(ctx.prefs.max-rating)
  // What the footer helpers print (`sections/footer.typ`).
  [#metadata(_cv-details(cv, ctx.labels))<alta-cv>]
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
// the CV. At the next major (#239) `alta()` returns this directly.
#let _alta-content(cv, labels: (:), preferences: (:)) = context {
  _check-template-preferences(labels, preferences)
  let prepared = _prepare(cv, labels, preferences)
  let (cv, sections, ctx) = prepared
  // For `altacv` to set at the top level: `set document` fails inside a
  // container, where this may sit (`#block(alta(cv))`).
  [#metadata(_pdf-metadata(cv, sections, ctx.labels))<alta-internal-document>]
  _cv-content(prepared)
}

// `alta()` on its own (removed in the next major, #239): the template's
// body and the preferences that stand in for the set rules after it,
// the footer among them, around the CV.
#let _alta-standalone(cv, labels: (:), preferences: (:)) = context {
  let prepared = _prepare(cv, labels, preferences)
  let (cv, sections, ctx) = prepared
  set document(.._pdf-metadata(cv, sections, ctx.labels))
  show: _standalone.with(ctx.prefs, ctx.labels, _footer(cv, ctx))
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
  let theme = _checked-theme(theme)
  show: _document.with(_theme-for(theme, (:)), _default-preferences.margin)
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
