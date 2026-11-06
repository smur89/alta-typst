// expect: margin must be a length, `auto`, or a dict of them (e.g. (x: 1cm, y: 1.5cm)), got: (x: "1cm")
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (margin: (x: "1cm")))
