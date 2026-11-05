// Forest-green titles, moss details, a sage rule and olive greys.

#import "../colour.typ": _hue-colours

#let theme = (
  colours: _hue-colours((
    name: rgb("#1E3F27"),
    heading: rgb("#2E5E3A"),
    headingRule: rgb("#AFC6AE"),
    accent: rgb("#3A7048"),
    emphasis: rgb("#222A23"),
    body: rgb("#56605A"),
  )),
)
