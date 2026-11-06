// `justify` through the JSON Resume mapping, a scoped `set par` rather
// than `alta()`'s show rules: the prose takes it (the intro, an entry's
// summary and highlights), the rows of facts and keywords, the
// interest rows and the rating rows don't.

#import "/lib.typ": alta, altacv

#show: altacv

#let seen = state("seen", (:))
#let probe(name) = it => {
  context {
    let justify = par.justify
    seen.update(s => s + ((name): justify))
  }
  it
}
#show <alta-summary>: probe("summary")
#show <alta-org>: probe("facts")
#show <alta-keyword>: probe("keyword")
#show "Highlight": probe("highlight")
#show "Trad": probe("interest")
#show <alta-rating-label>: probe("rating")

#let cv = (
  basics: (name: "Jane Doe"),
  work: (
    (
      name: "Acme",
      position: "Engineer",
      summary: "Led the team.",
      highlights: ("Highlight",),
      keywords: ("Scala",),
    ),
  ),
  interests: ((name: "Music", keywords: ("Trad",)),),
  languages: ((language: "Irish", fluency: "Native"),),
)

#alta(cv, preferences: (justify: true))
#context assert.eq(seen.get(), (
  summary: true,
  facts: false,
  keyword: false,
  highlight: true,
  interest: false,
  rating: false,
))
#alta(cv)
#context assert.eq(seen.get().values(), (false,) * 6)
