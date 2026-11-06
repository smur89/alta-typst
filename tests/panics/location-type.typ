// expect: work[].location must be a string or a dict matching JSON Resume's {address, postalCode, city, countryCode, region}, got: 42
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (work: ((name: "Acme", location: 42),)))
