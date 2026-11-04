// expect: basics.url must be a non-empty URL string when preferences.qrCode is `auto`
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (qrCode: auto))
