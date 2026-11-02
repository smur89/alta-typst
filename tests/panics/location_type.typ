// expect: work[].location must be a string or a dict
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (work: ((name: "Acme", location: 42),)))
