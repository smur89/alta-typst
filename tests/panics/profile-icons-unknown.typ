// expect: preferences.profile-icons.Kaggle must be a FontAwesome icon name (https://fontawesome.com/search, e.g. "kaggle"), got: "kagle"
#import "/lib.typ": alta

#alta(
  (basics: (name: "Jane Doe")),
  preferences: (profile-icons: (Kaggle: "kagle")),
)
