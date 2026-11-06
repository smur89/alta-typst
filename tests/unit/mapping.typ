// The JSON Resume mapping (`adapter/json-resume.typ`) through the
// blocks' overrides: the name from `basics.name` with no document
// title, aligned per `header-text-align`; the labels in the document's
// language under the template's; the owners from the CV; a skill's
// numeric rating; and a fluency it can't rate shown as text.

#import "/lib.typ": altacv
#import "/adapter/json-resume.typ": resume

#show: altacv.with(labels: (skills: "Buanna"))
#set text(lang: "ga")

#let names = state("names", ())
#show <alta-name>: it => {
  names.update(xs => xs + (it,))
  it
}
#let sections = state("sections", ())
#show heading.where(level: 1): it => {
  sections.update(xs => xs + (it.body,))
  it
}
#let owners = state("owners", ())
#show strong: it => {
  owners.update(xs => xs + (it.body,))
  it
}
#let full-dots = state("full-dots", 0)
#show <alta-rating-full>: it => {
  full-dots.update(n => n + 1)
  it
}
#let fluent = state("fluent", 0)
#show "Conversational": it => {
  fluent.update(n => n + 1)
  it
}

#resume(
  (
    basics: (name: "Jane Doe"),
    publications: (
      (name: "Paper", authors: ("Jane Doe", "J. Doe", "Alex Roe")),
    ),
    skills: (
      (name: "Go", keywords: ("Channels",), custom: (altacv: (rating: 2))),
    ),
    languages: ((language: "French", fluency: "Conversational"),),
  ),
  preferences: (owner-names: ("J. Doe",), max-rating: 3),
)

// `header-text-align` aligns the header as an `align` around it would.
#resume(
  (basics: (name: "Alex Roe")),
  preferences: (
    header-text-align: right,
  ),
)

#context {
  let (first, aligned) = query(<alta-name>).map(n => n.location().position().x)
  assert(aligned > first)
  assert.eq(names.final(), ([Jane Doe], [Alex Roe]))
  // Irish where not overridden.
  assert.eq(sections.final(), ([Foilseacháin], [Buanna], [Teangacha]))
  assert.eq(owners.final(), ([Jane Doe], [J. Doe]))
  assert.eq(full-dots.final(), 2)
  assert.eq(fluent.final(), 1)
}
