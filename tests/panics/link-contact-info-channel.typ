// expect: Unknown link-contact-info key(s): "fax"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (link-contact-info: (fax: true)))
