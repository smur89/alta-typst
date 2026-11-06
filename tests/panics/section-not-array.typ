// expect: work must be an array, got: (name: "Acme")
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (work: (name: "Acme")))
