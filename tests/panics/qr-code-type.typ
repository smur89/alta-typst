// expect: qr-code must be `none`, `auto`, or a non-empty URL string, got: true
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (qr-code: true))
