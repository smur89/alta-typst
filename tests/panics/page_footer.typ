// expect: pageFooter must be `none`
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (pageFooter: true))
