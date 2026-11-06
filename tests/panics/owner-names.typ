// expect: owner-names must be an array of strings, got: "J. Doe"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (owner-names: "J. Doe"))
