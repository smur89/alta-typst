// The template's theme is scoped: content after a nested, scoped
// `altacv` reads the outer template's theme again, not the nested one
// (`_document` pushes its theme and pops it after its body).
// Standalone `alta()`'s theme isn't: content after it reads it, as it
// did before the template.

#import "/lib.typ": alta, altacv, themes
#import "/internal/context.typ": _theme

#let accent() = _theme().colours.accent

#alta((basics: (name: "Jane Doe")), preferences: (theme: themes.navy))
#context assert.eq(accent(), themes.navy.colours.accent)

#show: altacv.with(theme: themes.teal)
#context assert.eq(accent(), themes.teal.colours.accent)
#[
  #show: altacv.with(theme: themes.navy)
  #context assert.eq(accent(), themes.navy.colours.accent)
]
#context assert.eq(accent(), themes.teal.colours.accent)

// Inside the template a user's size rule sets a heading's size exactly:
// the theme's sizes are show-set rules over Typst's own. The probe
// reads the size `part`'s text renders at, under `rule` after the
// show line.
#let assert-size(part, rule, expected, cv) = [
  #show: altacv
  #show: rule
  #let seen = state("size-" + part, none)
  #show label("alta-" + part): it => {
    box(context {
      let size = text.size
      seen.update(size)
    })
    it
  }
  #alta((basics: (name: "Jane Doe")) + cv)
  #context assert.eq(seen.final().to-absolute(), expected)
]
#let work = (work: ((name: "Acme", position: "Engineer"),))
#let typed = (
  publications: ((name: "Paper", releaseDate: "2024", type: "Articles"),),
)

#assert-size(
  "name",
  it => {
    show title: set text(size: 30pt)
    it
  },
  30pt,
  (:),
)
#assert-size(
  "section-title",
  it => {
    show heading: set text(size: 16pt)
    it
  },
  16pt,
  work,
)
#assert-size(
  "group-title",
  it => {
    show heading.where(level: 2): set text(size: 20pt)
    it
  },
  20pt,
  typed,
)
