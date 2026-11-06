// expect: photo-size must be a length
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (photo-size: "6em"))
