// expect: theme.font must be a font family name
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (theme: (font: 12)))
