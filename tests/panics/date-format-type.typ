// expect: dateFormat must be "long"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (dateFormat: 1))
