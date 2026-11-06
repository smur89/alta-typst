// expect: Unknown preferences key(s): "image-position"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (image-position: left))
