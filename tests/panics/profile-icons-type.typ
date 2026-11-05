// expect: preferences.profile-icons.kaggle must be a FontAwesome icon name
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (profile-icons: (kaggle: 5)))
