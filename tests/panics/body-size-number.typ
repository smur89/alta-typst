// expect: body-size must be a positive absolute length (e.g. 10pt), got: 10
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (body-size: 10))
