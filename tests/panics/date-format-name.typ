// expect: date-format must be "long"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (date-format: "medium"))
