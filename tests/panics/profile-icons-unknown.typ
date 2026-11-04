// expect: preferences.profileIcons.Kaggle must be a FontAwesome icon name
#import "/lib.typ": alta

#alta(
  (basics: (name: "Jane Doe")),
  preferences: (profileIcons: (Kaggle: "kagle")),
)
