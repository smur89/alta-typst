// Skills and interests: one row per `{name, keywords}` group, the
// name as a label pill and the keywords as pills after it, wrapping
// under a hanging indent.

#import "../design/theme.typ": _theme
#import "../context.typ": _body-size-state
#import "../primitives.typ": _tag-gap, _tag-row, tag

// The dash is `text(...)`, not markup, so it can't parse as a list
// bullet. The `_tag-gap` after it mirrors the gap `tag()` leaves on
// its left, so the dash sits centred between the pills.
#let _keyword-rows(groups) = context {
  let body-size = _body-size-state.get()
  let (gap, hanging-indent, dash) = _theme.keyword-row
  let row-gap = gap * body-size
  for (name, keywords, ..) in groups {
    block(above: 0pt, below: row-gap, par(
      hanging-indent: hanging-indent,
      leading: row-gap,
      {
        tag(name, label: true)
        text(dash)
        _tag-gap(body-size)
        _tag-row(keywords)
      },
    ))
  }
}
