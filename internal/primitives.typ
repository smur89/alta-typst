// Low-level rendering primitives shared by every section renderer.
// `name`, `term`, `tag`, `divider` are re-exported as public surface
// from `lib.typ` for callers composing custom layouts; the leading-
// underscore helpers are used internally by the section renderers.

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

// Bold accent-coloured line — designed for the company / institution
// row beneath a role or education entry.
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

// An entry's italic prose preamble (`summary`). Softer than `name()`
// (the bold accent line) so it doesn't compete with the headings or
// the bullets around it. Absent values render nothing.
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

// One icon-led part of a term row; a `none` body renders nothing. The
// 50% default lines a period up with a location column.
#let _term_part(icon-name, body, width: 50%) = if body != none {
  box(width: width, {
    icon(icon-name)
    body
  })
}

// Either side may be `none` — the box is skipped, so undated /
// unlocated entries don't emit a stray icon.
#let term(period, location: none) = {
  if period == none and location == none { return }
  _term_row({
    _term_part("calendar", period)
    _term_part("location", location)
  })
}

// The date + location term row of a dated entry. `location` is a
// string or JSON Resume's structured dict; `key` names the section in
// panic messages (e.g. "education" → "education[].location").
#let _entry_term(entry, key, prefs, labels) = term(
  _format_date_range(entry, prefs, labels),
  location: _format_location(
    entry.at("location", default: none),
    key + "[].location",
  ),
)

// `label: true` is the category-heading variant (darker fill, bold
// text) — used to distinguish a group's leading pill from the item
// pills that follow it on the same row. `trailing: false` suppresses
// the inter-tag gap that would otherwise sit after the pill; callers
// composing a row of tags pass `false` on the final one so the row
// doesn't end on dead horizontal space.
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
    let top = top + 0% // a plain length or ratio, as a relative
    top.length.to-absolute() + top.ratio * page.height
  }
}

// Inter-entry dashed rule. Suppressed when it would render near the
// top of a page — Typst has no "stick to previous block" attribute, so
// when an entry overflows onto a new page the divider that preceded
// it would otherwise orphan above the first item on that page. "Near"
// is within 0.5cm of the top margin, a buffer for any section heading
// that immediately follows, so it tracks `preferences.margin`.
#let divider() = context {
  let body-size = _body_size_state.get()
  if here().position().y < _top_margin() + 0.5cm { return }
  v(0.3 * body-size)
  line(length: 100%, stroke: _divider_stroke)
  v(0.3 * body-size)
}

// Buckets `items` under `key-of(item)` in first-occurrence order
// (Typst dicts preserve insertion order). Keys must be strings.
#let _group_by(items, key-of) = items.fold((:), (acc, item) => {
  let key = key-of(item)
  acc + ((key): acc.at(key, default: ()) + (item,))
})

// Rules between neighbours only, so sections don't end on a stray rule.
#let _join_with_dividers(items, render) = items.map(render).join(divider())

// Buckets by `item.type` when it's a non-empty string, else under
// `fallback` — the optional JSON Resume `type` field drives the
// `====` subheadings in projects and publications. A non-string
// `type` (a number, a dict) pools under `fallback` rather than
// crashing as a dict key.
#let _group_by_type(items, fallback) = _group_by(items, item => {
  let raw = _string_at(item, "type")
  if raw != none { raw } else { fallback }
})

// The common section skeleton: level-2 heading, then one unbreakable
// block per entry joined by dividers. Empty `entries` renders nothing
// — not even the heading — so callers filter out unusable entries
// first and the "no orphan heading" rule holds by construction.
#let _section(heading, entries, render-entry) = if entries.len() > 0 {
  [== #heading]
  _join_with_dividers(entries, e => block(breakable: false, render-entry(e)))
}

// Suppresses the inter-tag gap on the final pill so rows don't end
// in dead horizontal space. `label` forwards to `tag` so a caller can
// render the whole row in the darker category variant (e.g. project
// roles, set apart from the lighter keyword pills).
#let _tag_row(items, label: false) = {
  for (i, item) in items.enumerate() {
    tag(item, label: label, trailing: i < items.len() - 1)
  }
}
