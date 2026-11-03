// `{name, keywords}` groups, one row each: skills' as pills, the
// name as a label pill and the keywords wrapping under the first of
// them; interests' as a line of text.

#import "../design/styles.typ": _treat
#import "../design/theme.typ": _theme
#import "../context.typ": _body-size-state
#import "../primitives.typ": _tag-gap, _tag-row, tag

// The dash is `text(...)`, not markup, so it can't parse as a list
// bullet. The `_tag-gap` after it mirrors the gap `tag()` leaves on
// its left, so the dash sits centred between the pills. The hanging
// indent is the label's measured width, so wrapped keywords line up
// under the first; a label wider than `keyword-row.indent-max` of the
// column hangs nothing, so its keywords keep room to wrap.
#let _keyword-rows(groups) = context {
  let body-size = _body-size-state.get()
  let (gap, dash, indent-max) = _theme.keyword-row
  let row-gap = gap * body-size
  for (name, keywords, ..) in groups {
    let label = {
      tag(name, label: true)
      text(dash)
      _tag-gap(body-size)
    }
    block(above: 0pt, below: row-gap, layout(size => {
      let indent = measure(label).width
      par(
        hanging-indent: if indent > indent-max * size.width { 0pt } else {
          indent
        },
        leading: row-gap,
        {
          label
          _tag-row(keywords)
        },
      )
    }))
  }
}

// `Music: Trad, Jazz`, one line per group, the name in the emphasis
// colour and `treatment.label` (bold by default). Quieter than
// `_keyword-rows`' pills, for groups a reader skims past.
#let _label-rows(groups) = {
  let (colour, separator, treatment, ..) = _theme
  par(
    groups
      .map(((name, keywords, ..)) => [#text(
          fill: colour.emphasis,
          _treat(treatment.label, name),
        )#separator.label#keywords.join(separator.items)])
      .join(linebreak()),
  )
}
