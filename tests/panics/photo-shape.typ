// expect: photo-shape must be "circle", "rounded", or "square", got: "oval"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (photo-shape: "oval"))
