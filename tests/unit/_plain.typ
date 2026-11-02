// Flattens content to its plain text, so a check can compare what a
// helper renders without depending on how the content is structured.
#let plain(c) = if c == none or type(c) == str { c } else if c.has("text") {
  plain(c.text)
} else if c.has("children") { c.children.map(plain).join() } else if (
  c.has("body")
) { plain(c.body) } else if c.func() == [ ].func() { " " } else { "" }
