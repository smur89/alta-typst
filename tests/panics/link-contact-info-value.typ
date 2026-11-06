// expect: link-contact-info.email must be a bool, got: "no"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (link-contact-info: (email: "no")))
