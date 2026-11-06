// expect: preferences.publication-icons has keys that collide after lowercasing (matching is case-insensitive): "Talk" and "talk"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (publication-icons: (Talk: "book", talk: "file")))
