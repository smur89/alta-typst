// expect: paper must be a paper name (e.g. "a4"), got: 4
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (paper: 4))
