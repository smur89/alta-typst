// The intro between the header and the first section: the CV's
// summary, from the slot `sections/intro.typ` maps `basics.summary`
// onto. (The objective sits in the header, under the headline.)

#import "../context.typ": _theme-state
#import "../primitives.typ": _prose

#let _intro-block(summary: none) = if summary != none {
  context {
    let body-size = text.size
    let (above, below) = _theme-state.get().intro
    v(above * body-size)
    _prose(summary)
    v(below * body-size)
  }
}
