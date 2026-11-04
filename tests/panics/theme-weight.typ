// expect: theme.type.headline.weight must be a font weight
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (theme: (type: (headline: (weight: "heavyy")))))
