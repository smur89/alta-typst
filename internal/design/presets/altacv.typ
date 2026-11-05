// Two hues: dark red over a gold rule, the name near-black and the
// tagline in the red, over warm greys.

#import "../colour.typ": _hue-colours

#let theme = (
  colours: _hue-colours((
    name: rgb("#1C1414"),
    heading: rgb("#4A0E0E"),
    headingRule: rgb("#D9BE73"),
    accent: rgb("#8F0D0D"),
    emphasis: rgb("#2B2222"),
    body: rgb("#5F5654"),
  ))
    + (tagline: rgb("#8F0D0D")),
)
