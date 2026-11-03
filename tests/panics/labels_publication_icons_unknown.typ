// expect: publicationIcons.talk must be "book", "calendar"
#import "/lib.typ": alta

// The deprecated label's icon names are checked like the preference's.
#let cv = (basics: (name: "Jane Doe"))
#alta(cv, labels: (publicationIcons: (talk: "podium")))
