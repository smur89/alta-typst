// expect: colours must be a dictionary
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (accent: rgb("#1A3A6C"), colours: red))
