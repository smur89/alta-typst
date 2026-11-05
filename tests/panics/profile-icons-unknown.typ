// expect: preferences.profile-icons.Kaggle must be a FontAwesome icon name
#import "/lib.typ": alta

#alta(
  (basics: (name: "Jane Doe")),
  preferences: (profile-icons: (Kaggle: "kagle")),
)
