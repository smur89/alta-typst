// expect: preferences.colours isn't an alta() preference
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (colours: (accent: red)))
