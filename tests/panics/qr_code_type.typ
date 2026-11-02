// expect: qrCode must be `none`, `auto`, or a URL string
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (qrCode: true))
