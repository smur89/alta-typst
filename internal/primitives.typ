// Low-level rendering primitives shared by the section renderers.
// `name`, `term`, `tag`, `divider` are re-exported from `lib.typ` for
// custom layouts; underscored helpers are internal.

#import "state.typ": (
  _accent_state, _body_colour, _body_size_state, _divider_colour,
)
#import "icons.typ": icon
#import "text.typ": _present, _string_at, styled-link
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

// The type scale below body text: `_small` for secondary lines (a
// subtitle, a fluency label, publication authors), `_meta` for the
// quietest (publication dates and identifiers).
#let _small(body) = context text(
  0.85 * _body_size_state.get(),
  fill: _body_colour,
  body,
)
#let _meta(body) = context text(
  0.8 * _body_size_state.get(),
  fill: _body_colour.lighten(35%),
  body,
)

// The gap `tag()` leaves after a pill.
#let _tag_gap = context h(0.25 * _body_size_state.get())

#let name(body) = context {
  let body-size = _body_size_state.get()
  block(above: 0pt, below: 0.6 * body-size, _accent_strong(body))
}

// A small line under an entry's heading: a project's client, a
// referee's attribution. Absent bodies render nothing.
#let _subtitle(body) = if _present(body) {
  context block(below: 0.5 * _body_size_state.get(), _small(body))
}

// An organisation line via `name()`, linked when `url` is present
// (`link()` inherits the bold accent). An absent organisation renders
// nothing rather than an empty block that leaves a blank line.
#let _org_line(org, url: none) = if _present(org) {
  name(if _present(url) { link(url, org) } else { org })
}

// Italic, so a `summary` doesn't compete with the bold `name()` line.
// Its own paragraph, so whatever follows starts on a new line.
#let _preamble(body) = if _present(body) { par(emph(body)) }

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
  if trailing { _tag_gap }
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

// Drives the `====` subheadings in projects and publications. A
// missing or non-string `type` pools under `fallback` rather than
// crashing as a dict key.
#let _group_by_type(items, fallback) = _group_by(items, item => {
  let raw = _string_at(item, "type")
  if raw != none { raw } else { fallback }
})

// Empty `entries` renders nothing, not even the heading, so callers
// filter unusable entries first and no heading is orphaned. Every
// section renders through this; `body` is its content.
#let _section_frame(heading, entries, body) = if entries.len() > 0 {
  [== #heading]
  body
}

// Each entry unbreakable, with rules between neighbours only, so a
// section doesn't end on a stray rule.
#let _entry_blocks(entries, render-entry, dividers: true) = (
  entries
    .map(e => block(breakable: false, render-entry(e)))
    .join(if dividers { divider() })
)

#let _section(heading, entries, render-entry, dividers: true) = _section_frame(
  heading,
  entries,
  _entry_blocks(entries, render-entry, dividers: dividers),
)

// `_section` with entries clustered under `====` subheadings, one per
// `groups` key (see `_group_by`); `subheading(key, items)` gives each
// subheading's text.
#let _grouped_section(
  heading,
  groups,
  subheading,
  render-entry,
  dividers: true,
) = _section_frame(heading, groups, {
  for (key, items) in groups.pairs() {
    [==== #subheading(key, items)]
    _entry_blocks(items, render-entry, dividers: dividers)
  }
})

// `label` renders the whole row in the darker variant (e.g. project
// roles, set apart from keyword pills).
#let _tag_row(items, label: false) = {
  for (i, item) in items.enumerate() {
    tag(item, label: label, trailing: i < items.len() - 1)
  }
}

// One CV entry in a fixed slot order, so every section lays its
// entries out alike; an absent slot renders nothing. The title is
// always the accent italic of `styled-link`, linked or not. `term` is
// a rendered row (`term()`, `_entry_term`); `body` holds whatever a
// section adds after the highlights, inline with the `tags` pills.
#let _entry(
  title: none,
  url: none,
  org: none,
  org-url: none,
  subtitle: none,
  roles: (),
  term: none,
  summary: none,
  highlights: (),
  body: none,
  tags: (),
) = {
  if _present(title) [=== #styled-link(title, dest: url)]
  _org_line(org, url: org-url)
  _subtitle(subtitle)
  // The person's roles as darker pills, set apart from the `tags`.
  if roles.len() > 0 {
    context block(below: 0.4 * _body_size_state.get(), _tag_row(
      roles,
      label: true,
    ))
  }
  term
  _preamble(summary)
  for bullet in highlights [- #bullet]
  body
  _tag_row(tags)
}
