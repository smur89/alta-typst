// Crimson titles and details under an oxblood name, over a dusty-rose
// rule and warm, brownish greys.

#import "../colour.typ": _hue-colours

#let theme = (
  colours: _hue-colours((
    name: rgb("#6E1C1F"),
    heading: rgb("#9E2A2B"),
    headingRule: rgb("#DDB0A8"),
    accent: rgb("#9E2A2B"),
    emphasis: rgb("#2B2322"),
    body: rgb("#645A57"),
  )),
)
