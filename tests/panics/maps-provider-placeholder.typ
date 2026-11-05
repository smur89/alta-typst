// expect: maps-provider must be `none` or a URL template string containing `{q}`
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (maps-provider: "https://maps.example.com/"))
