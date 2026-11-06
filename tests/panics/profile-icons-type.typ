// expect: preferences.profile-icons.kaggle must be a FontAwesome icon name (https://fontawesome.com/search, e.g. "kaggle"), got: 5
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (profile-icons: (kaggle: 5)))
