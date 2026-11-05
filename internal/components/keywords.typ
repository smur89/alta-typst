// `{name, keywords}` groups, one row each: skills' as pills, the
// name as a label pill and the keywords wrapping under the first of
// them; interests' as a line of text.

#import "../context.typ": _theme-state
#import "../primitives.typ": _tag-gap, _tag-row, tag

// The dash is `text(...)`, not markup, so it can't parse as a list
// bullet. The `_tag-gap` after it mirrors the gap `tag()` leaves on
// its left, so the dash sits centred between the pills. The hanging
// indent is the label's measured width, so wrapped keywords line up
// under the first; a label wider than `keyword-row.indent-max` of the
// column hangs nothing, so its keywords keep room to wrap. A group's
// optional `mark` (a skill level: dots or its text) follows the label.
#let _keyword-rows(groups) = context {
  let body-size = text.size
  let theme = _theme-state.get()
  let (gap, dash, indent-max) = theme.keyword-row
  let row-gap = gap * body-size
  layout(size => for (name, keywords, ..group) in groups {
    let mark = group.at("mark", default: none)
    let label = {
      tag(name, label: true)
      if mark != none {
        mark
        _tag-gap(theme, body-size)
      }
      text(dash)
      _tag-gap(theme, body-size)
    }
    let indent = measure(label).width
    block(above: 0pt, below: row-gap, par(
      hanging-indent: if indent > indent-max * size.width { 0pt } else {
        indent
      },
      leading: row-gap,
      {
        label
        _tag-row(keywords)
      },
    ))
  })
}

// `Music: Trad, Jazz`, one line per group, the name in the emphasis
// colour and `treatment.label` (bold by default). Quieter than
// `_keyword-rows`' pills, for groups a reader skims past.
#let _label-rows(groups) = context {
  let (separator, treatment, colours) = _theme-state.get()
  par(
    groups
      .map(((name, keywords, ..)) => [#text(
          fill: colours.emphasis,
          (treatment.label)(name),
        )#separator.label#keywords.join(separator.items)])
      .join(linebreak()),
  )
}
