// expect: colours.accent must be a colour
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (colours: (accent: auto)))
