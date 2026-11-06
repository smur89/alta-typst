// expect: work[].location.city must be a string or content, got: 5
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (work: ((name: "Acme", location: (city: 5, postalCode: 12345)),)))
