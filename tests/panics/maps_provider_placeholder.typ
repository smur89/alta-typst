// expect: must contain the `{q}` placeholder
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (mapsProvider: "https://maps.example.com/"))
