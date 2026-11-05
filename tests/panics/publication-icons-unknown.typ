// expect: preferences.publication-icons.talk must be "book", "calendar"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (publication-icons: (talk: "podium")))
