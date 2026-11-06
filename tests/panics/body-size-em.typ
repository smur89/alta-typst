// expect: body-size must be a positive absolute length (e.g. 10pt), got: 1em
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (body-size: 1em))
