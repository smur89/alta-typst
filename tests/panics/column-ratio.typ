// expect: columnRatio must be a number in (0, 1]
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (columnRatio: 1.5))
