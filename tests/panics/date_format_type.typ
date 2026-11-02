// expect: dateFormat must be a string
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (dateFormat: 1))
