// expect: Unknown colours key(s): "headingrule"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (colours: (headingrule: red)))
