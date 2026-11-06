// Ratings as dots: language ratings, LinkedIn fluency strings and
// skill levels, on the default 5-dot scale and on others
// (`preferences.max-rating`). Documents:
//
//   1. Language ratings: integer, fractional (half-dot), boundary
//      values (0 and the configured max) and the fluency-string
//      fallback.
//   2. A 6-dot scale (CEFR's 6 levels) with numeric ratings, which are
//      used as given: the maximum (6) and a fractional value above the
//      default cap.
//   3–5. LinkedIn `fluency` strings scale to `max-rating`, rounded to
//      the nearest half, so they fit any dot count instead of
//      overflowing a smaller scale; a numeric `custom.altacv.rating` is
//      used as given. Fluency matches case-insensitively (Portuguese:
//      lowercase, padded). The default 5-dot scale, then 4 and 6 dots.
//   6. `skills[].level`: a known level turns into dots on the
//      `max-rating` scale (`Master` fills them, `Intermediate` 3 of 5),
//      `custom.altacv.rating` overrides it, an unknown level shows as
//      text, and a group with neither keeps today's look.
//   7. The same, forced to text (`skill-level-display: "text"`).

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  languages: (
    (language: "English", custom: (altacv: (rating: 5))),
    (language: "French", custom: (altacv: (rating: 4.5))),
    (language: "Spanish", custom: (altacv: (rating: 2.5))),
    (language: "Portuguese", custom: (altacv: (rating: 0))),
    (language: "German", fluency: "Elementary"),
    (language: "Italian", fluency: "Native"),
  ),
))

#pagebreak()

// A 6-dot scale with numeric ratings, which are used as given —
// covering the maximum (6) and a fractional value above the
// default cap.
#alta(
  (
    basics: (name: "Jean Dupont", email: "jean@example.com"),
    languages: (
      (language: "French", custom: (altacv: (rating: 6))),
      (language: "English", custom: (altacv: (rating: 5.5))),
      (language: "German", custom: (altacv: (rating: 4))),
      (language: "Spanish", custom: (altacv: (rating: 2))),
    ),
  ),
  preferences: (max-rating: 6),
)

#pagebreak()

#let fluency-cv(name) = (
  basics: (name: name, email: "jane@example.com"),
  languages: (
    (language: "English", fluency: "Native"),
    (language: "German", fluency: "Full Professional"),
    (language: "Irish", fluency: "Professional Working"),
    (language: "French", fluency: "Limited Working"),
    (language: "Italian", fluency: "Elementary"),
    (language: "Spanish", custom: (altacv: (rating: 2))),
    (language: "Portuguese", fluency: " professional working "),
  ),
)

#alta(fluency-cv("Five Dots"))

#pagebreak()

#alta(fluency-cv("Four Dots"), preferences: (max-rating: 4))

#pagebreak()

#alta(fluency-cv("Six Dots"), preferences: (max-rating: 6))

#pagebreak()

#let skills-cv = (
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

#alta(skills-cv)

#pagebreak()

#alta(skills-cv, preferences: (skill-level-display: "text"))
