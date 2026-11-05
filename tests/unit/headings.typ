// Typst's built-in heading text sizes, which `_content-styles`
// (`design/styles.typ`) divides out to read the body size inside a
// heading. Typst doesn't document them, so a release that changes
// them fails here rather than silently resizing every CV.

#set text(10pt)
#let sizes = state("heading-sizes", ())
#show heading: it => context { let size = text.size; sizes.update(s => s + (size,)) }
= One
== Two
=== Three
==== Four
#context assert.eq(
  sizes.final().map(s => s.to-absolute()),
  (14pt, 12pt, 10pt, 10pt),
  message: "Typst's built-in heading sizes changed: update `_content-styles`",
)
