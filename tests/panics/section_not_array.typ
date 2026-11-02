// expect: work must be an array
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (work: (name: "Acme")))
