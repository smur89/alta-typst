// `alta()` takes the template's form wherever `#show: altacv` reaches,
// and only there. Page 1: a scoped template with the CV inside a
// `block`, where the standalone `set page` would fail; it renders only
// the CV, navy, boxed. Page 2: the same CV after the scope ends,
// standalone again: teal, on A5, with its own last-updated footer.

#import "../lib.typ": alta, altacv, themes

#let cv = (
  basics: (name: "Jane Doe", label: "Software Engineer"),
  meta: (lastModified: "2024-05-01"),
)

// The boxed CV stays on page 1; the standalone one sets its own page.
#context assert.eq(
  query(<alta-cv>).map(marker => marker.location().page()),
  (1, 2),
)

#[
  #show: altacv.with(theme: themes.navy)
  #block(stroke: 0.5pt, inset: 8pt, alta(cv))
]

#alta(cv, preferences: (paper: "a5", last-modified-footer: true))
