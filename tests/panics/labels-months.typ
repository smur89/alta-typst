// expect: labels.months must be an array of 12 strings, got: ("Jan",)
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, labels: (months: ("Jan",)))
