// expect: qrCode must be a non-empty string
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (qrCode: ""))
