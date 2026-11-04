// Low-level rendering pieces shared across sections: the text styles,
// the term row, pills and tag rows, the divider and icon headings.
// `name`, `term`, `tag`, `divider`, `styled-link` are re-exported from `lib.typ` for
// custom layouts; underscored helpers are internal.

#import "design/styles.typ": _part, _treat
#import "design/theme.typ": _theme
#import "context.typ": _accent-state, _body-size-state
#import "util/values.typ": _join-present, _present
#import "icons.typ": icon

// The accent text `name()` sets on its own line, for inline use (an
// entry's organisation on its facts line). Regular weight, so the
// title above it leads.
#let _accent-text(body) = context text(fill: _accent-state.get(), body)

// The quietest lines (publication dates, identifiers); absent bodies
// render nothing.
#let _meta(body) = if _present(body) {
  text(fill: _theme.colour.secondary, body)
}

// The gap `tag()` leaves after a pill. Takes the CV's body size, not
// `em`, since `tag()` is public and may sit outside `alta()`'s text.
#let _tag-gap(body-size) = h(_theme.tag.gap * body-size)

/// An accent-coloured line, for an organisation on a line of its own in
/// a custom layout.
///
/// - body (content): The text.
/// -> content
#let name(body) = context {
  let body-size = _body-size-state.get()
  block(
    above: 0pt,
    below: _theme.entry.name-below * body-size,
    _accent-text(body),
  )
}

// Groups of facts on one line (`Manager, Pied Piper · 2024`): the
// parts of a group joined by `separator.items`, the groups by
// `separator.facts`. Absent parts and emptied groups drop out; `none`
// when nothing is left.
#let _fact-line(..groups) = _join-present(
  groups.pos().map(g => _join-present(g, _theme.separator.items)),
  _theme.separator.facts,
)

// A summary as a paragraph of prose: the paragraph labelled
// `<alta-internal-prose>` for `justify` (`design/styles.typ`), its text the
// public `<alta-summary>` part.
#let _prose(body, treatment: "none") = [#par(_treat(
  treatment,
  _part("summary", body),
))<alta-internal-prose>]

// Set apart (`treatment.preamble`, italic by default) so a `summary`
// doesn't compete with the facts line above it. Its own paragraph, so
// whatever follows starts on a new line.
#let _preamble(body) = if _present(body) {
  _prose(body, treatment: _theme.treatment.preamble)
}

// The term row's frame: indented text under an entry's heading.
#let _term-row(body) = context {
  let body-size = _body-size-state.get()
  let (below, inset) = _theme.term
  block(
    above: 0pt,
    below: below * body-size,
    inset: (left: inset * body-size),
    text(body-size, body),
  )
}

// `body` led by its icon, kept on one line; absent bodies render
// nothing, so no stray icon.
#let _icon-fact(icon-name, body, alt: none) = if _present(body) {
  box({
    icon(icon-name, alt: alt)
    body
  })
}

// Half the row each, so a period lines up with a location column.
#let _term-part(icon-name, body) = if _present(body) {
  box(width: 50%, _icon-fact(icon-name, body))
}

// An absent side is skipped, so undated or unlocated entries don't
// emit a stray icon.
/// A date and an optional location on one row, each led by its icon.
/// Renders nothing when both are absent.
///
/// - period (content, str, none): The date or date range.
/// - location (content, str, none): The place.
/// -> content
#let term(period, location: none) = {
  if not (_present(period) or _present(location)) { return }
  _term-row({
    _term-part("calendar", period)
    _term-part("location", location)
  })
}

// `label: true` is the darker, bold category pill. Pass
// `trailing: false` on a row's last pill so it doesn't end on a gap.
/// A pill, as altacv draws a skill.
///
/// - body (content): The pill's text.
/// - label (bool): The darker, bold category pill (a skill group's
///   label).
/// - trailing (bool): Leave the gap after the pill; `false` on a row's
///   last pill, so the next line doesn't start indented.
/// -> content
#let tag(body, label: false, trailing: true) = context {
  let body-size = _body-size-state.get()
  let accent = _accent-state.get()
  let (
    fill,
    label-fill,
    text-darken,
    radius,
    inset,
    outset-y,
    weight,
    label-weight,
    ..,
  ) = _theme.tag
  let text-weight = if label { label-weight } else { weight }
  box(
    fill: accent.lighten(if label { label-fill } else { fill }),
    stroke: _theme.stroke-width.thin + accent,
    radius: radius,
    inset: (x: inset.x * body-size, y: inset.y * body-size),
    outset: (y: outset-y * body-size),
    // The box's look is the theme's; only its text is a `_part`.
    text(
      body-size,
      fill: accent.darken(text-darken),
      weight: text-weight,
      _part(if label { "pill-label" } else { "pill" }, body),
    ),
  )
  if trailing { _tag-gap(body-size) }
}

// The page's top margin as an absolute length. Typst's `auto` margin is
// 2.5/21 of the shorter page side.
#let _top-margin() = {
  let margin = page.margin
  let top = if type(margin) == dictionary { margin.top } else { margin }
  if top == auto { calc.min(page.width, page.height) * 2.5 / 21 } else {
    let rel = top + 0% // a plain length or ratio, as a relative
    rel.length.to-absolute() + rel.ratio * page.height
  }
}

// Typst has no keep-with-previous, so a divider before an entry that
// moved to a new page would orphan at its top. Suppress it within
// `clearance` of the top margin (headroom for a following heading), so
// it tracks `preferences.margin`. `rule: false` keeps the spacing
// without the line (`_divider-space`).
#let _divider(rule) = context {
  let body-size = _body-size-state.get()
  let (gap, dash, clearance) = _theme.divider
  if here().position().y < _top-margin() + clearance { return }
  v(gap * body-size)
  if rule {
    line(length: 100%, stroke: (
      paint: _theme.colour.border,
      thickness: _theme.stroke-width.thin,
      dash: dash,
    ))
  }
  v(gap * body-size)
}

/// The dashed grey rule altacv draws between entries.
/// -> content
#let divider() = _divider(true)
#let _divider-space() = _divider(false)

// A row of `tag()` pills, with no gap after the last.
#let _tag-row(items) = {
  for (i, item) in items.enumerate() {
    tag(item, trailing: i < items.len() - 1)
  }
}

// A `====` subheading led by an icon at the subheading's size. Read in
// context: `em` inside the heading is already scaled.
#let _icon-heading(icon-name, body) = [#context icon(
    icon-name,
    size: _theme.type.title.size * _body-size-state.get(),
    // The heading's own colour (`styles.typ`), not the icon's default.
    fill: text.fill,
  ) #body]

// The portrait, clipped to a square with corner `radius` (`50%`, a
// circle, by default). `image()` resolves a bare string path from
// the file that calls it, so this stays in `internal/`, where a bare
// `basics.image` has always resolved; `path` and `bytes` sources let
// callers anchor resolution at their own .typ instead. `alt` becomes
// the image's `/Alt` in tagged PDF output.
#let _portrait(source, size, alt, radius: 50%) = box(
  width: size,
  height: size,
  clip: true,
  radius: radius,
  image(source, fit: "cover", width: 100%, height: 100%, alt: alt),
)

// `body` linked to `dest` when it's present, so an empty `url` never
// becomes a dead link.
#let _link-if(dest, body) = if _present(dest) { link(dest, body) } else {
  body
}

// Entry titles look the same linked or not.
/// Text in altacv's entry-title style (the accent, italic), linked when
/// `dest` is set.
///
/// - content (content): The title.
/// - dest (str, none): A URL to link it to.
/// -> content
#let styled-link(content, dest: none) = context {
  let accent = _accent-state.get()
  let styled = _treat(_theme.treatment.link, text(fill: accent, content))
  _link-if(dest, styled)
}
