// expect: image-stack-order must be "above" or "below", got: "over"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (image-stack-order: "over"))
