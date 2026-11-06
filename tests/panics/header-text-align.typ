// expect: header-text-align must be left, center, or right, got: "middle"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (header-text-align: "middle"))
