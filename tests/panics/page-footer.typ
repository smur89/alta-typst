// expect: page-footer must be `none`, `auto`, or a content value, got: true
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (page-footer: true))
