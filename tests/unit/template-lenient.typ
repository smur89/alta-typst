// The fields 1.8.0 read leniently, a value of the wrong type reading
// as absent, still read so in the template: `alta()` drops them
// (`_canonical-cv`) before its mapping, which takes JSON Resume's
// types, sees the CV. Standalone `alta()`'s work keywords are in
// work-keywords.typ.

#import "/lib.typ": alta, altacv

#show: altacv

// Only an array of text draws work keywords.
#alta((
  basics: (name: "Jane Doe"),
  work: (
    (name: "A", keywords: ("Go", "Rust")),
    (name: "B", keywords: "Go"),
    (name: "C", keywords: ("Go", 5)),
    (name: "D", keywords: (Go: 1)),
  ),
))
#context assert.eq(query(<alta-keyword>).len(), 2)

// A publication's or project's `type`, a citation part, an author or
// an identifier, and a reference's attribution or flag, of the wrong
// type: each as if absent.
#let seen = state("seen", ())
#show <alta-summary>: it => {
  seen.update(xs => xs + (it,))
  it
}
#alta((
  basics: (name: "Jane Doe"),
  projects: ((name: "P", type: 3),),
  publications: (
    (
      name: "Paper",
      type: 1,
      volume: 12,
      issue: "3",
      authors: ("Jane Doe", 5),
      identifiers: (doi: "10.1/x", isbn: 978),
    ),
  ),
  references: (
    (
      name: "R",
      reference: "Great.",
      relationship: 5,
      date: (year: 2024),
      availableOnRequest: "yes",
    ),
  ),
))
// The untyped project takes no group heading, and the untyped
// publication the articles' (an icon, then the text); the entries'
// titles are text alone.
#context assert.eq(
  query(heading.where(level: 2))
    .filter(h => h.body.has("children"))
    .map(h => h.body.children.last()),
  ([Articles],),
)
// The quote, not the on-request line.
#context assert.eq(seen.get(), ([Great.],))
