// expect: image-position must be left, right, top, or bottom
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (image-position: "top"))
