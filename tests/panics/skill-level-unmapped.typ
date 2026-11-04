// expect: skills[].level must be one of "Beginner", "Novice", "Intermediate", "Advanced", "Expert", or "Master" with `skillLevelDisplay: "rating"`
#import "/lib.typ": alta

#alta(
  (
    basics: (name: "Jane Doe"),
    skills: ((name: "Data", level: "Comfortable", keywords: ("SQL",)),),
  ),
  preferences: (skillLevelDisplay: "rating"),
)
