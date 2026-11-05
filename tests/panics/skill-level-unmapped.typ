// expect: skills[].level must be one of "Beginner", "Novice", "Intermediate", "Advanced", "Expert", or "Master" with `skill-level-display: "rating"`
#import "/lib.typ": alta

#alta(
  (
    basics: (name: "Jane Doe"),
    skills: ((name: "Data", level: "Comfortable", keywords: ("SQL",)),),
  ),
  preferences: (skill-level-display: "rating"),
)
