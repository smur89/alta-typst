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
