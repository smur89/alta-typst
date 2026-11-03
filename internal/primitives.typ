// Low-level rendering pieces shared across sections: the text styles,
// the term row, pills and tag rows, the divider and icon headings.
// `name`, `term`, `tag`, `divider` are re-exported from `lib.typ` for
// custom layouts; underscored helpers are internal.

#import "state.typ": _accent_state, _body_size_state
#import "theme.typ": _theme
#import "icons.typ": icon
#import "text.typ": _present

// The bold accent text `name()` sets on its own line, for inline use
// (e.g. a certificate's issuer on its term row).
#let _accent_strong(body) = context text(
  weight: "bold",
  fill: _accent_state.get(),
  body,
)

// The type scale below body text: `_small` for secondary lines (a
// subtitle, a fluency label, publication authors), `_meta` for the
// quietest (publication dates and identifiers). In `em`, as they only
// sit in body text; absent bodies render nothing.
#let _small(body) = if _present(body) {
  text(_theme.size.small * 1em, fill: _theme.colour.body, body)
}

#let _meta(body) = if _present(body) {
  text(_theme.size.meta * 1em, fill: _theme.colour.meta, body)
}

// The gap `tag()` leaves after a pill. Takes the CV's body size, not
// `em`, since `tag()` is public and may sit outside `alta()`'s text.
#let _tag_gap(body-size) = h(_theme.tag.gap * body-size)

#let name(body) = context {
  let body-size = _body_size_state.get()
  block(
    above: 0pt,
    below: _theme.entry.name-below * body-size,
    _accent_strong(body),
  )
}

// Italic, so a `summary` doesn't compete with the bold `name()` line.
// Its own paragraph, so whatever follows starts on a new line.
#let _preamble(body) = if _present(body) { par(emph(body)) }

// The term row's frame: indented small text under an entry's heading.
#let _term_row(body) = context {
  let body-size = _body_size_state.get()
  let (below, inset) = _theme.term
  block(
    above: 0pt,
    below: below * body-size,
    inset: (left: inset * body-size),
    text(_theme.size.term * body-size, body),
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

// `label: true` is the darker, bold category pill. Pass
// `trailing: false` on a row's last pill so it doesn't end on a gap.
#let tag(body, label: false, trailing: true) = context {
  let body-size = _body_size_state.get()
  let accent = _accent_state.get()
  let (
    fill,
    label-fill,
    text-darken,
    stroke,
    radius,
    inset,
    outset-y,
    ..,
  ) = _theme.tag
  let text-weight = if label { "bold" } else { "regular" }
  box(
    fill: accent.lighten(if label { label-fill } else { fill }),
    stroke: stroke + accent,
    radius: radius,
    inset: (x: inset.x * body-size, y: inset.y * body-size),
    outset: (y: outset-y * body-size),
    text(
      _theme.size.small * body-size,
      fill: accent.darken(text-darken),
      weight: text-weight,
      body,
    ),
  )
  if trailing { _tag_gap(body-size) }
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
// `clearance` of the top margin (headroom for a following heading), so
// it tracks `preferences.margin`.
#let divider() = context {
  let body-size = _body_size_state.get()
  let (stroke, gap, clearance) = _theme.divider
  if here().position().y < _top_margin() + clearance { return }
  v(gap * body-size)
  line(length: 100%, stroke: stroke)
  v(gap * body-size)
}

// `label` renders the whole row in the darker variant (e.g. project
// roles, set apart from keyword pills).
#let _tag_row(items, label: false) = {
  for (i, item) in items.enumerate() {
    tag(item, label: label, trailing: i < items.len() - 1)
  }
}

// A label pill, a dash, then `items` as pills, wrapping under a
// hanging indent. Called in `context`, which supplies `body-size`.
// `text("-")`, not `[-]`, which markup parses as a list bullet. The
// `_tag_gap` after it mirrors the gap `tag()` leaves on its left, so
// the dash sits centred between the pills.
#let _keyword_row(body-size, label, items) = {
  let (gap, hanging-indent) = _theme.keyword-row
  let row-gap = gap * body-size
  block(above: 0pt, below: row-gap, par(
    hanging-indent: hanging-indent,
    leading: row-gap,
    {
      tag(label, label: true)
      text("-")
      _tag_gap(body-size)
      _tag_row(items)
    },
  ))
}

// A `====` subheading led by an icon at the subheading's size. Read in
// context: `em` inside the heading is already scaled.
#let _icon_heading(icon-name, body) = [#context icon(
    icon-name,
    size: _theme.size.subheading * _body_size_state.get(),
  ) #body]
