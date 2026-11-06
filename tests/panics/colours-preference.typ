// expect: preferences.colours isn't an alta() preference: theme the CV with `#show: altacv.with(theme: themes.navy)` before `#alta(cv)`, and recolour a theme as `themes.navy + (colours: (..themes.navy.colours, accent: ..))`.
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (colours: (accent: red)))
