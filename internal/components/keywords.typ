// `{name, keywords}` groups, one row each: skills' as pills, the
// name as a label pill and the keywords wrapping under the first of
// them; interests' as a line of text.

#import "../design/theme.typ": _theme
#import "../context.typ": _body-size-state
#import "../primitives.typ": _tag-gap, _tag-row, tag

// The dash is `text(...)`, not markup, so it can't parse as a list
// bullet. The `_tag-gap` after it mirrors the gap `tag()` leaves on
// its left, so the dash sits centred between the pills.
#let _keyword-rows(groups) = context {
  let body-size = _body-size-state.get()
  let (gap, dash) = _theme.keyword-row
  let row-gap = gap * body-size
  for (name, keywords, ..) in groups {
    block(above: 0pt, below: row-gap, grid(
      columns: (auto, 1fr),
      {
        tag(name, label: true)
        text(dash)
        _tag-gap(body-size)
      },
      par(leading: row-gap, _tag-row(keywords)),
    ))
  }
}

// `Music: Trad, Jazz`, the name in bold, one line per group. Quieter
// than `_keyword-rows`' pills, for groups a reader skims past.
#let _label-rows(groups) = par(
  groups
    .map(((name, keywords, ..)) => [#text(
        weight: _theme.font-weight.bold,
        fill: _theme.colour.emphasis,
        name,
      )#_theme.separator.label#keywords.join(_theme.separator.items)])
    .join(linebreak()),
)
