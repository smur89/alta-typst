// expect: Unknown theme key(s): "fonts"
#import "/lib.typ": alta, themes

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (theme: themes.navy + (fonts: "Lato")))
