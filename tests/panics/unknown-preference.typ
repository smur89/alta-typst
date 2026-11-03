// expect: Unknown preferences key(s): "colour"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (colour: red))
