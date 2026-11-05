// expect: page-footer must be `none`
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (page-footer: true))
