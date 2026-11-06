// expect: uppercase-name must be a bool, got: 1
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (uppercase-name: 1))
