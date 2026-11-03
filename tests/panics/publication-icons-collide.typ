// expect: preferences.publicationIcons has keys that collide after lowercasing
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (publicationIcons: (Talk: "book", talk: "file")))
