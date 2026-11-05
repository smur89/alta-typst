// Navy section titles under a deeper name, the details a brighter
// cobalt so they don't sink into the ink; blue-leaning greys.

#import "../colour.typ": _hue-colours

#let theme = (
  colours: _hue-colours((
    name: rgb("#13284A"),
    heading: rgb("#1A3A6C"),
    headingRule: rgb("#A3B5D1"),
    accent: rgb("#2C5491"),
    emphasis: rgb("#1C2330"),
    body: rgb("#535C6B"),
  )),
)
