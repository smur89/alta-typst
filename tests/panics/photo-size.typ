// expect: photo-size must be a length (e.g. 6em), got: "6em"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (photo-size: "6em"))
