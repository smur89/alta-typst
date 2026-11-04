// expect: preferences.profileIcons.kaggle must be a FontAwesome icon name
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (profileIcons: (kaggle: 5)))
