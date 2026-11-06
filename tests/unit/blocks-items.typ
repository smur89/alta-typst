// The item blocks' own decisions: a publication's owners are the
// document's author unless given, a skill level is dots when it's a
// number or a rating term, else its text, and a rating's text value
// takes the dots' place.

#import "/lib.typ": altacv, label-row, publication, rating, skill-row
#import "/internal/blocks.typ": _plain

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
#let empty-dots = state("empty-dots", 0)
#show <alta-rating-empty>: it => {
  empty-dots.update(n => n + 1)
  it
}
#let half-dots = state("half-dots", 0)
#show <alta-rating-half>: it => {
  half-dots.update(n => n + 1)
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
// Content's text, as an owner is matched and a photo's alt reads:
// a gap or a line break is a space, a negative kern nothing.
#assert.eq(_plain([Jane#h(0.3em)Doe]), "Jane Doe")
#assert.eq(_plain([Jane#h(1fr)Doe]), "Jane Doe")
#assert.eq(_plain([Jane#linebreak()Doe]), "Jane Doe")
#assert.eq(_plain([T#h(-0.1em)eX]), "TeX")
#publication(title: "B", authors: ([Jane#h(0.3em)Doe],))[]
#context assert.eq(owners.get(), ([jane doe], [Jane Doe]))
// `owners` replaces the document's author, matched the same way.
#publication(
  title: "C",
  authors: ("Jane Doe", "J. Doe", "Alex Roe"),
  owners: (" j. doe", "ALEX ROE"),
)[]
#context assert.eq(owners.get(), ([jane doe], [Jane Doe], [J. Doe], [Alex Roe]))
#publication(title: "D", authors: ("Jane Doe",), owners: ())
#context assert.eq(owners.get().len(), 4)

= Skills
#skill-row("Typst", ("Markup",), level: "Expert")
#context assert.eq(full-dots.get(), 5)
#skill-row("Rust", ("Traits",), level: "Fluent-ish")
// No more dots, and the level as written.
#context assert.eq(full-dots.get(), 5)
#context assert.eq(levels.get(), 1)
// A number is that many dots, halves too, out of `max`; a term is its
// share of `max`.
#skill-row("Go", ("Channels",), level: 2.5, max: 4)
#context assert.eq(
  (full-dots.get(), half-dots.get(), empty-dots.get()),
  (7, 1, 1),
)
#skill-row("Zig", ("Comptime",), level: "Expert", max: 3)
#context assert.eq((full-dots.get(), empty-dots.get()), (10, 1))
// `max: auto` is `rating()`'s: 5 outside `alta()`.
#skill-row("C", ("Pointers",), level: 1)
#context assert.eq((full-dots.get(), empty-dots.get()), (11, 5))

= Languages
// A text value in the dots' place, labelled as a rating row is.
#let rating-labels = state("rating-labels", 0)
#show <alta-rating-label>: it => {
  rating-labels.update(n => n + 1)
  it
}
#let fluent = state("fluent", 0)
#show "Conversational": it => {
  fluent.update(n => n + 1)
  it
}
#rating("Irish", "Conversational")
#rating("French", [Conversational])
#context assert.eq((rating-labels.get(), fluent.get()), (2, 2))
#context assert.eq((full-dots.get(), empty-dots.get()), (11, 5))

= Interests
#label-row("Music", ("Trad", "Jazz"))
