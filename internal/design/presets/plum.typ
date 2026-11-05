// Plum titles, orchid details, a lavender rule and mauve greys.

#import "../colour.typ": _hue-colours

#let theme = (
  colours: _hue-colours((
    name: rgb("#421B4C"),
    heading: rgb("#5F2A6E"),
    headingRule: rgb("#CDB3D4"),
    accent: rgb("#75398A"),
    emphasis: rgb("#2A2230"),
    body: rgb("#5E5763"),
  )),
)
