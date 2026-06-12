// Skills with per-group ratings: JSON Resume `level` strings, numeric
// `rating` (with fractional half-dot precision), the original
// label-only form (no level), and a level-only group with no keywords.

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  skills: (
    (name: "Languages",  level: "Master",       keywords: ("Scala", "Haskell")),
    (name: "Infra",      rating: 3.5,           keywords: ("AWS", "Kafka", "Kubernetes")),
    (name: "Frontend",   level: "Intermediate", keywords: ("TypeScript", "React")),
    (name: "Databases",  level: "Beginner",     keywords: ("PostgreSQL",)),
    // No level / rating — renders the original label + keywords form.
    (name: "Tools",                             keywords: ("Git", "Make")),
    // Level-only — no keywords. Still renders so the rating shows.
    (name: "Leadership", level: "Advanced"),
  ),
))
