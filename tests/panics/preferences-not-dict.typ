// expect: preferences must be a dictionary, got: "navy"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: "navy")
