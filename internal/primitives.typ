// Low-level rendering primitives shared by the section renderers.
// `name`, `term`, `tag`, `divider` are re-exported from `lib.typ` for
// custom layouts; underscored helpers are internal.

#import "state.typ": _accent_state, _body_size_state, _divider_colour
#import "icons.typ": icon
#import "text.typ": _present, _string_at
#import "dates.typ": _format_date_range
#import "location.typ": _format_location

// The dashed rule `divider()` draws between entries.
#let _divider_stroke = (
  paint: _divider_colour,
  thickness: 0.6pt,
  dash: "dashed",
)

// The bold accent text `name()` sets on its own line, for inline use
// (e.g. a certificate's issuer on its term row).
#let _accent_strong(body) = context text(
  weight: "bold",
  fill: _accent_state.get(),
  body,
)

#let name(body) = context {
  let body-size = _body_size_state.get()
  block(above: 0pt, below: 0.6 * body-size, _accent_strong(body))
}

// An organisation line via `name()`, linked when `url` is present
// (`link()` inherits the bold accent). An absent organisation renders
// nothing rather than an empty block that leaves a blank line.
#let _org_line(org, url: none) = if _present(org) {
  name(if _present(url) { link(url, org) } else { org })
}

// Italic, so a `summary` doesn't compete with the bold `name()` line.
#let _preamble(body) = if _present(body) { emph(body) }

// The term row's frame: indented small text under an entry's heading.
#let _term_row(body) = context {
  let body-size = _body_size_state.get()
  block(
    above: 0pt,
    below: 0.8 * body-size,
    inset: (left: 0.3 * body-size),
    text(0.9 * body-size, body),
  )
}

// The 50% default lines a period up with a location column.
#let _term_part(icon-name, body, width: 50%) = if body != none {
  box(width: width, {
    icon(icon-name)
    body
  })
}

// A `none` side is skipped, so undated or unlocated entries don't
// emit a stray icon.
#let term(period, location: none) = {
  if period == none and location == none { return }
  _term_row({
    _term_part("calendar", period)
    _term_part("location", location)
  })
}

// `key` names the section in panic messages ("education[].location").
#let _entry_term(entry, key, prefs, labels) = term(
  _format_date_range(entry, prefs, labels),
  location: _format_location(
    entry.at("location", default: none),
    key + "[].location",
  ),
)

// `label: true` is the darker, bold category pill. Pass
// `trailing: false` on a row's last pill so it doesn't end on a gap.
#let tag(body, label: false, trailing: true) = context {
  let body-size = _body_size_state.get()
  let accent = _accent_state.get()
  let fill-colour = if label { accent.lighten(70%) } else {
    accent.lighten(85%)
  }
  let text-weight = if label { "bold" } else { "regular" }
  box(
    fill: fill-colour,
    stroke: 0.5pt + accent,
    radius: 2.5pt,
    inset: (x: 0.4 * body-size, y: 0.15 * body-size),
    outset: (y: 0.15 * body-size),
    text(0.85 * body-size, fill: accent.darken(15%), weight: text-weight, body),
  )
  if trailing { h(0.25 * body-size) }
}

// The page's top margin as an absolute length. Typst's `auto` margin is
// 2.5/21 of the shorter page side.
#let _top_margin() = {
  let margin = page.margin
  let top = if type(margin) == dictionary { margin.top } else { margin }
  if top == auto { calc.min(page.width, page.height) * 2.5 / 21 } else {
    let rel = top + 0% // a plain length or ratio, as a relative
    rel.length.to-absolute() + rel.ratio * page.height
  }
}

// Typst has no keep-with-previous, so a divider before an entry that
// moved to a new page would orphan at its top. Suppress it within
// 0.5cm of the top margin (headroom for a following heading), so it
// tracks `preferences.margin`.
#let divider() = context {
  let body-size = _body_size_state.get()
  if here().position().y < _top_margin() + 0.5cm { return }
  v(0.3 * body-size)
  line(length: 100%, stroke: _divider_stroke)
  v(0.3 * body-size)
}

// First-occurrence order (Typst dicts keep insertion order). Keys
// must be strings.
#let _group_by(items, key-of) = items.fold((:), (acc, item) => {
  let key = key-of(item)
  acc + ((key): acc.at(key, default: ()) + (item,))
})

// Rules between neighbours only, so sections don't end on a stray rule.
#let _join_with_dividers(items, render) = items.map(render).join(divider())

// Drives the `====` subheadings in projects and publications. A
// missing or non-string `type` pools under `fallback` rather than
// crashing as a dict key.
#let _group_by_type(items, fallback) = _group_by(items, item => {
  let raw = _string_at(item, "type")
  if raw != none { raw } else { fallback }
})

// Empty `entries` renders nothing, not even the heading, so callers
// filter unusable entries first and no heading is orphaned.
#let _section(heading, entries, render-entry) = if entries.len() > 0 {
  [== #heading]
  _join_with_dividers(entries, e => block(breakable: false, render-entry(e)))
}

// `label` renders the whole row in the darker variant (e.g. project
// roles, set apart from keyword pills).
#let _tag_row(items, label: false) = {
  for (i, item) in items.enumerate() {
    tag(item, label: label, trailing: i < items.len() - 1)
  }
}
