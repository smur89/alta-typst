// expect: imageStackOrder must be "above" or "below"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (imageStackOrder: "over"))
