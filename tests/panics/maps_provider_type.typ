// expect: mapsProvider must be a URL template string
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (mapsProvider: true))
