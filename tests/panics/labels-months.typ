// expect: labels.months must be an array of 12 strings
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, labels: (months: ("Jan",)))
