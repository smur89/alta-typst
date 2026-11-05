// expect: preferences.publication-icons has keys that collide after lowercasing
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (publication-icons: (Talk: "book", talk: "file")))
