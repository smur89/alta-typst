// `skills[].level`: a known level turns into dots on the
// `maxRating` scale (`Master` fills them, `Intermediate` 3 of 5),
// `custom.altacv.rating` overrides it, an unknown level shows as
// text, and a group with neither keeps today's look. The second
// document forces text (`skillLevelDisplay: "text"`).

#import "../lib.typ": alta

#let cv = (
  basics: (name: "Jane Doe"),
  skills: (
    (name: "Backend", level: "Master", keywords: ("Scala", "Kafka")),
    (name: "Infra", level: "Intermediate", keywords: ("AWS", "Terraform")),
    (
      name: "Frontend",
      level: "Beginner",
      custom: (altacv: (rating: 2.5)),
      keywords: ("React",),
    ),
    (name: "Data", level: "Comfortable", keywords: ("SQL", "dbt")),
    (name: "Tooling", keywords: ("Nix", "Bazel")),
  ),
)

#alta(cv)

#pagebreak()

#alta(cv, preferences: (skillLevelDisplay: "text"))
