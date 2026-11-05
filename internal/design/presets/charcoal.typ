// Greys only, for a print-first CV: a near-black name, charcoal
// titles, a silver rule, and a cool slate that keeps the details
// apart from the text.

#import "../colour.typ": _hue-colours

#let theme = (
  colours: _hue-colours((
    name: rgb("#1E2124"),
    heading: rgb("#3B3B3B"),
    headingRule: rgb("#B7BCC1"),
    accent: rgb("#4A525A"),
    emphasis: rgb("#23262A"),
    body: rgb("#595E63"),
  )),
)
