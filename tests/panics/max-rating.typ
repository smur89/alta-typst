// expect: maxRating must be a positive integer
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (maxRating: 0))
