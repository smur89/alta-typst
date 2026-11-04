// expect: margin must be a length
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (margin: (x: "1cm")))
