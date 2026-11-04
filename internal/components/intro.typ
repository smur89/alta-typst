// The intro between the header and the first section, laid out from
// the slots `sections/intro.typ` maps `objective` and
// `basics.summary` onto.

#import "../design/theme.typ": _theme
#import "../context.typ": _accent-state, _body-size-state
#import "../util/values.typ": _join-present
#import "../primitives.typ": _preamble, _prose

// The objective (a forward-looking goal), then the summary
// (background); either alone keeps the summary's spacing. The
// objective is set off like a pull quote so it reads apart from the
// summary without being louder than it, in colour or in a
// black-and-white print.
#let _intro-block(objective: none, summary: none) = {
  if objective != none or summary != none {
    context {
      let body-size = _body-size-state.get()
      let (above, inset, gap, below) = _theme.intro
      v(above * body-size)
      _join-present(
        (
          if objective != none {
            block(
              stroke: (left: _theme.stroke-width.thick + _accent-state.get()),
              inset: (left: inset.left * body-size, y: inset.y * body-size),
              _preamble(objective),
            )
          },
          if summary != none { _prose(summary) },
        ),
        v(gap * body-size),
      )
      v(below * body-size)
    }
  }
}
