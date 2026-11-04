// expect: headingFont must be `auto`, a font family name or a non-empty array of them
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (headingFont: 12))
