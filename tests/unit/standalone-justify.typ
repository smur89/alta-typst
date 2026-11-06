// Standalone `alta()` justifies its prose as the paragraphs around the
// call are: a `set par(justify: true)` before it reaches the intro, an
// entry's summary and highlights, and not the rows of facts and
// keywords, the interest rows or the rating rows.

#import "/lib.typ": alta

#let seen = state("seen", (:))
#let probe(name) = it => {
  context {
    let justify = par.justify
    seen.update(s => s + ((name): justify))
  }
  it
}
#show "Intro.": probe("intro")
#show "Led the team.": probe("summary")
#show <alta-org>: probe("facts")
#show <alta-keyword>: probe("keyword")
#show "Highlight": probe("highlight")
#show "Trad": probe("interest")
#show <alta-rating-label>: probe("rating")

#let cv = (
  basics: (name: "Jane Doe", summary: "Intro."),
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

#alta(cv)
#context assert.eq(seen.get().values().dedup(), (false,))
#pagebreak()
#set par(justify: true)
#alta(cv)
#context assert.eq(
  seen.get(),
  (intro: true, summary: true, highlight: true)
    + (facts: false, keyword: false, interest: false, rating: false),
)
