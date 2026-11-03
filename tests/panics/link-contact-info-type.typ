// expect: linkContactInfo must be a bool or a dict
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (linkContactInfo: "yes"))
