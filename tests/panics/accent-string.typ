// expect: accent must be a colour (e.g. rgb("#1A3A6C")), got: "teal"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (accent: "teal"))
