// expect: uppercaseName must be a bool
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (uppercaseName: 1))
