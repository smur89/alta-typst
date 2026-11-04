// expect: ownerNames must be an array of strings
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (ownerNames: "J. Doe"))
