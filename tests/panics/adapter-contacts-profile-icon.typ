// expect: basics-contacts(): no icon for the profile network "Kaggle"; map it in `icons:` (e.g. (kaggle: "kaggle"))
#import "/lib.typ": adapter

#adapter.basics-contacts((profiles: ((network: "Kaggle", username: "jd"),)))
