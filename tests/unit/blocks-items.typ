// The item blocks' own decisions: a publication's owner is the
// document's author, and a skill level is dots when it's a rating term,
// else its text.

#import "/lib.typ": altacv, label-row, publication, skills

#set document(author: "Jane Doe")
#show: altacv

// The theme's `treatment.owner` is `strong` (and its
// `treatment.label`, which `label-row` sets): one per owner set apart.
#let owners = state("owners", ())
#show strong: it => {
  owners.update(o => o + (it.body,))
  it
}
#let full-dots = state("full-dots", 0)
#show <alta-rating-full>: it => {
  full-dots.update(n => n + 1)
  it
}
#let levels = state("levels", 0)
#show "Fluent-ish": it => {
  levels.update(n => n + 1)
  it
}

= Publications
// Matched trimmed and ignoring case, as `alta()` matches its owner.
#publication(title: "A", authors: ("A. N. Other", " jane doe "))[]
#context assert.eq(owners.get(), ([jane doe],))

= Skills
#skills("Typst", ("Markup",), level: "Expert")
#context assert.eq(full-dots.get(), 5)
#skills("Rust", ("Traits",), level: "Fluent-ish")
// No more dots, and the level as written.
#context assert.eq(full-dots.final(), 5)
#context assert.eq(levels.final(), 1)

= Interests
#label-row("Music", ("Trad", "Jazz"))
