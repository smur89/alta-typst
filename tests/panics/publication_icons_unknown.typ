// expect: preferences.publicationIcons.talk must be "book", "calendar"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (publicationIcons: (talk: "podium")))
