// expect: Unknown linkContactInfo key(s): "fax"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (linkContactInfo: (fax: true)))
