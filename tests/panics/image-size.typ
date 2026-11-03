// expect: imageSize must be a length
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (imageSize: "6em"))
