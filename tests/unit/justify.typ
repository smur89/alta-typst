// `set par(justify: true)` over a CV: the prose takes it (the intro,
// an entry's summary and highlights), the rows of facts and keywords,
// the interest rows and the rating rows don't. Standalone `alta()`
// justifies as the paragraphs around the call are; in the template,
// so do `alta()` and a direct `resume()` through the JSON Resume
// mapping. Without it, nothing is justified. How far justified prose
// stretches is justify-width.typ's.

#import "/lib.typ": alta, altacv
#import "/adapter/json-resume.typ": resume

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
#let prose = (intro: true, summary: true, highlight: true)
#let rows = (facts: false, keyword: false, interest: false, rating: false)

// Standalone.
#alta(cv)
#context assert.eq(seen.get().values().dedup(), (false,))
#pagebreak()
#[
  #set par(justify: true)
  #alta(cv)
  #context assert.eq(seen.get(), prose + rows)
]

// In the template.
#show: altacv
#seen.update((:))
#alta(cv)
#context assert.eq(seen.get().values().dedup(), (false,))
#[
  #set par(justify: true)
  #alta(cv)
  #context assert.eq(seen.get(), prose + rows)
  #resume(cv)
  #context assert.eq(seen.get(), prose + rows)
]
