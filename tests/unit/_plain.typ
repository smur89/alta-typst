// Flattens content to its plain text, so a check can compare what a
// helper renders without depending on how the content is structured.
// Bold renders as `*…*`, so a check can pin what is bold. Any other
// element panics rather than vanishing from the text unnoticed.
#let plain(c) = if c == none or type(c) == str { c } else if (
  c.func() == strong
) {
  "*" + plain(c.body) + "*"
} else if c.has("text") { plain(c.text) } else if c.has("children") {
  c.children.map(plain).join()
} else if c.has("body") { plain(c.body) } else if c.func() == [ ].func() {
  " " // the space element
} else { panic("plain(): unhandled element " + repr(c.func())) }
