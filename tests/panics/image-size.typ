// expect: image-size must be a length
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (image-size: "6em"))
