// expect: basics.url must be a non-empty URL string when preferences.qr-code is `auto`
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (qr-code: auto))
