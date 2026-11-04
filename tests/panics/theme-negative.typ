// expect: theme.stroke-width.thin must be a positive number
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (theme: (stroke-width: (thin: -1))))
