// expect: preferences sets an option both in camelCase and in kebab-case; keep the kebab-case one: "columnRatio" and "column-ratio"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (columnRatio: 0.5, column-ratio: 0.6))
