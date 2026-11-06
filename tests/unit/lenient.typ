// The fields 1.8.0 read leniently, a value of the wrong type reading
// as absent rather than failing. Work keywords, which 1.8.0 drew none
// of, through standalone `alta()` and then the template; the rest in
// the template, where `alta()` drops them (`_canonical-cv`) before
// its mapping, which takes JSON Resume's types, sees the CV.

#import "/lib.typ": adapter, alta, altacv
#import "/internal/data/canonical.typ": _canonical-cv

// Only an array of text draws work keywords: those drawn so far.
#let keywords() = query(selector(<alta-keyword>).before(here())).len()
#let work = (
  basics: (name: "Jane Doe"),
  work: (
    (name: "A", keywords: ("Go", "Rust")),
    (name: "B", keywords: "Go"),
    (name: "C", keywords: ("Go", 5)),
    (name: "D", keywords: (Go: 1)),
  ),
)
#alta(work)
#context assert.eq(keywords(), 2)
#pagebreak()

#show: altacv
#alta(work)
#context assert.eq(keywords(), 4)

// A publication's or project's `type`, a citation part, an author or
// an identifier, and a reference's attribution or flag, of the wrong
// type: each as if absent.
#let paper = (
  name: "Paper",
  type: 1,
  volume: 12,
  issue: "3",
  authors: ("Jane Doe", 5),
  identifiers: (doi: "10.1/x", isbn: 978),
)
// The valid parts beside them survive.
#let kept = (
  _canonical-cv(
    (basics: (name: "Jane Doe"), publications: (paper,)),
    adapter.preferences(),
  )
    .publications
    .first()
)
#assert.eq(
  (kept.issue, kept.authors, kept.identifiers, "volume" in kept),
  ("3", ("Jane Doe",), (doi: "10.1/x"), false),
)
#let seen = state("seen", ())
#show <alta-summary>: it => {
  seen.update(xs => xs + (it,))
  it
}
#alta((
  basics: (name: "Jane Doe"),
  projects: ((name: "P", type: 3),),
  publications: (paper,),
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
