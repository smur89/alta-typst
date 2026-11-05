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

// Inside the template a user's size rule sets a section title's size
// exactly: the theme's sizes are show-set rules over Typst's own. The
// probe reads the size the title's text renders at.
#[
  #show: altacv
  #show heading: set text(size: 16pt)
  #let seen = state("section-size", none)
  #show <alta-section-title>: it => {
    box(context {
      let size = text.size
      seen.update(size)
    })
    it
  }
  #alta((
    basics: (name: "Jane Doe"),
    work: ((name: "Acme", position: "Engineer"),),
  ))
  #context assert.eq(seen.final().to-absolute(), 16pt)
]
