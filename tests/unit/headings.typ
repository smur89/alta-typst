// Typst's built-in heading text sizes, which `_content-styles`
// (`design/styles.typ`) divides out to read the body size inside a
// heading. Typst doesn't document them, so a release that changes
// them fails here rather than silently resizing every CV.

#set text(10pt)
#let sizes = state("heading-sizes", ())
#show heading: it => context {
  let size = text.size
  sizes.update(s => s + (size,))
}
= One
== Two
=== Three
==== Four
#context assert.eq(
  sizes.final().map(s => s.to-absolute()),
  (14pt, 12pt, 10pt, 10pt),
  message: "Typst's built-in heading sizes changed: update `_content-styles`",
)

// The title element's: 1.7em, bold.
#let title-size = state("title-size", none)
#set document(title: "T")
#show title: it => context {
  let size = text.size
  title-size.update(size)
}
#title()
#context assert.eq(
  title-size.final().to-absolute(),
  17pt,
  message: "Typst's built-in title size changed: update `_level-headings`",
)

// The space above a heading: 1.8× the body at level 1, 1.44× at level 2,
// which `_level-headings` sets for its level-1 sections to sit where
// standalone's level-2 ones do.
#let aboves = state("heading-aboves", ())
#show heading: it => context {
  let above = block.above.to-absolute()
  aboves.update(a => a + (above,))
}
= One
== Two
#context assert.eq(
  aboves.final(),
  (18pt, 14.4pt),
  message: "Typst's built-in heading spacing changed: update `_level-headings`",
)
