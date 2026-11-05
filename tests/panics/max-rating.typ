// expect: max-rating must be a positive integer
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (max-rating: 0))
