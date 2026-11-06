// A skill or interest group without a `name`, which JSON Resume
// doesn't require (an empty one reads the same), draws its keywords
// without the category tag or the label: standalone `alta()`, then the
// template's mapping, which draws the same tags.

#import "/lib.typ": alta, altacv

#let cv = (
  basics: (name: "Jane Doe"),
  skills: ((keywords: ("Zig", "Ada")), (name: "", keywords: ("C",))),
  interests: ((keywords: ("Chess",)),),
)
#let chess = counter("chess")
#show "Chess": it => chess.step() + it

// The tags drawn so far, and whether the unnamed interest is drawn.
#let counts() = (
  query(selector(<alta-tag>).before(here())).len(),
  query(selector(<alta-tag-category>).before(here())).len(),
  chess.get().first(),
)

#alta(cv)
#context assert.eq(counts(), (3, 0, 1))

#pagebreak()
#[
  #show: altacv
  #alta(cv)
]
#context assert.eq(counts(), (6, 0, 2))
