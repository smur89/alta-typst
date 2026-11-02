// expect: preferences.qrCode is `auto` but basics.url is missing
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (qrCode: auto))
