// expect: theme.type.headline.size must be a positive number
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (theme: (type: (headline: (size: "big")))))
