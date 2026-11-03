// The intro between the header and the first section, laid out from
// the slots `sections/intro.typ` maps `objective` and
// `basics.summary` onto.

#import "../design/theme.typ": _theme
#import "../context.typ": _accent_state, _body_size_state
#import "../util/values.typ": _join_present
#import "../primitives.typ": _preamble

// The objective (a forward-looking goal), then the summary
// (background); either alone keeps the summary's spacing. The
// objective is set off like a pull quote so it reads apart from the
// summary without being louder than it, in colour or in a
// black-and-white print.
#let _intro_block(objective: none, summary: none) = {
  if objective != none or summary != none {
    context {
      let body-size = _body_size_state.get()
      let (above, rule, inset, gap, below) = _theme.intro
      v(above * body-size)
      _join_present(
        (
          if objective != none {
            block(
              stroke: (left: rule + _accent_state.get()),
              inset: (left: inset.left * body-size, y: inset.y * body-size),
              _preamble(objective),
            )
          },
          if summary != none { par(summary) },
        ),
        v(gap * body-size),
      )
      v(below * body-size)
    }
  }
}
