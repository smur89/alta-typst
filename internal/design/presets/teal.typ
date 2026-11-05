// The default theme: teal, its name a deep teal ink, over greys that
// lean green.

#import "../colour.typ": _hue-colours

#let theme = (
  colours: _hue-colours((
    name: rgb("#0A4F48"),
    heading: rgb("#00796B"),
    headingRule: rgb("#8EC5BD"),
    accent: rgb("#00796B"),
    emphasis: rgb("#1D2B29"),
    body: rgb("#53605D"),
  )),
)
