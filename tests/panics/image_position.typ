// expect: imagePosition must be "left", "right", or "center"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (imagePosition: "top"))
