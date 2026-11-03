// Low-level rendering pieces shared across sections: the text styles,
// the term row, pills and tag rows, the divider and icon headings.
// `name`, `term`, `tag`, `divider` are re-exported from `lib.typ` for
// custom layouts; underscored helpers are internal.

#import "design/styles.typ": _treat
#import "design/theme.typ": _theme
#import "context.typ": _accent-state, _body-size-state
#import "util/values.typ": _join-present, _present
#import "icons.typ": icon

// The bold accent text `name()` sets on its own line, for inline use
// (e.g. a certificate's issuer on its term row).
#let _accent-strong(body) = context text(
  weight: _theme.entry.org-weight,
  fill: _accent-state.get(),
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
#let _tag-gap(body-size) = h(_theme.tag.gap * body-size)

#let name(body) = context {
  let body-size = _body-size-state.get()
  block(
    above: 0pt,
    below: _theme.entry.name-below * body-size,
    _accent-strong(body),
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

// Set apart (`treatment.preamble`, italic by default) so a `summary`
// doesn't compete with the `name()` line. Its own paragraph, so
// whatever follows starts on a new line.
#let _preamble(body) = if _present(body) {
  par(_treat(_theme.treatment.preamble, body))
}

// The term row's frame: indented small text under an entry's heading.
#let _term-row(body) = context {
  let body-size = _body-size-state.get()
  let (below, inset) = _theme.term
  block(
    above: 0pt,
    below: below * body-size,
    inset: (left: inset * body-size),
    text(_theme.size.term * body-size, body),
  )
}

// The 50% default lines a period up with a location column.
#let _term-part(icon-name, body, width: 50%) = if body != none {
  box(width: width, {
    icon(icon-name)
    body
  })
}

// A `none` side is skipped, so undated or unlocated entries don't
// emit a stray icon.
#let term(period, location: none) = {
  if period == none and location == none { return }
  _term-row({
    _term-part("calendar", period)
    _term-part("location", location)
  })
}

// `label: true` is the darker, bold category pill. Pass
// `trailing: false` on a row's last pill so it doesn't end on a gap.
#let tag(body, label: false, trailing: true) = context {
  let body-size = _body-size-state.get()
  let accent = _accent-state.get()
  let (
    fill,
    label-fill,
    text-darken,
    stroke,
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
// it tracks `preferences.margin`.
#let divider() = context {
  let body-size = _body-size-state.get()
  let (stroke, gap, clearance) = _theme.divider
  if here().position().y < _top-margin() + clearance { return }
  v(gap * body-size)
  line(length: 100%, stroke: stroke)
  v(gap * body-size)
}

// `label` renders the whole row in the darker variant (e.g. project
// roles, set apart from keyword pills).
#let _tag-row(items, label: false) = {
  for (i, item) in items.enumerate() {
    tag(item, label: label, trailing: i < items.len() - 1)
  }
}

// A `====` subheading led by an icon at the subheading's size. Read in
// context: `em` inside the heading is already scaled.
#let _icon-heading(icon-name, body) = [#context icon(
    icon-name,
    size: _theme.size.subheading * _body-size-state.get(),
  ) #body]

// The circular portrait. `image()` resolves a bare string path from
// the file that calls it, so this stays in `internal/`, where a bare
// `basics.image` has always resolved; `path` and `bytes` sources let
// callers anchor resolution at their own .typ instead. `alt` becomes
// the image's `/Alt` in tagged PDF output.
#let _portrait(source, size, alt) = box(
  width: size,
  height: size,
  clip: true,
  radius: 50%,
  image(source, fit: "cover", width: 100%, height: 100%, alt: alt),
)

// `body` linked to `dest` when it's present, so an empty `url` never
// becomes a dead link.
#let _link-if(dest, body) = if _present(dest) { link(dest, body) } else {
  body
}

// Entry titles look the same linked or not. `_present` rather than
// `!= none` so an empty `url` doesn't become a dead link.
#let styled-link(content, dest: none) = context {
  let accent = _accent-state.get()
  let styled = _treat(_theme.treatment.link, text(fill: accent, content))
  _link-if(dest, styled)
}
