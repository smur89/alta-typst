// expect: image-shape must be "circle", "rounded", or "square"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (image-shape: "oval"))
