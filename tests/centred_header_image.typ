// `imagePosition: "center"` stacks the circular portrait on its own
// centred row with the name / label / contact block, instead of
// placing it beside them in a two-column header. Documents exercise:
//   1. Default stack order — portrait above the text block, with
//      centred text for the natural "centred header" look.
//   2. `imageStackOrder: "below"` — portrait underneath the contact
//      bar (the "photo as sign-off" variant).
//   3. Centred portrait with left-aligned text — the portrait still
//      sits on the page's centre axis even when `headerTextAlign`
//      keeps the text flush left.

#import "../lib.typ": alta

#alta(
  (basics: (
    name: "Centred Header, Photo Above",
    label: "imagePosition: \"center\" (default stack order)",
    email: "centre@example.com",
    phone: "+353 1 555 0100",
    location: "Dublin, Ireland",
    image: read("../examples/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (
    imagePosition: "center",
    headerTextAlign: "center",
  ),
)

#pagebreak()

#alta(
  (basics: (
    name: "Centred Header, Photo Below",
    label: "imageStackOrder: \"below\" — photo as sign-off",
    email: "below@example.com",
    phone: "+353 1 555 0100",
    location: "Dublin, Ireland",
    image: read("../examples/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (
    imagePosition: "center",
    imageStackOrder: "below",
    headerTextAlign: "center",
  ),
)

#pagebreak()

// `imagePosition` and `headerTextAlign` are orthogonal — a centred
// portrait pairs with left-aligned text without falling back to
// side-by-side layout.
#alta(
  (basics: (
    name: "Centred Photo, Left-Aligned Text",
    label: "Orthogonal: photo centred, text flush left",
    email: "mix@example.com",
    location: "Dublin, Ireland",
    image: read("../examples/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (
    imagePosition: "center",
  ),
)
