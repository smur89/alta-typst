// expect: Unknown labels key(s): "experiance"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, labels: (experiance: "Jobs"))
