// expect: Unknown theme key(s): "font"
#import "/lib.typ": alta, themes

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (theme: themes.navy + (font: "Lato")))
