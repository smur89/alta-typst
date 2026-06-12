// Structured `interests[]` follows JSON Resume's `{name, keywords}`
// shape — same renderer as `skills`. Coexists with `focusAreas`
// (prose) so both can appear on the same CV without overlap.
//
// Two documents:
//   1. Interests alongside focusAreas + skills — confirms they render
//      as three distinct sections.
//   2. `interests` with empty keywords on one entry is skipped without
//      emitting an empty pill row.

#import "../lib.typ": alta

#let cv = (
  basics: (name: "Jane Doe", email: "jane@example.com"),
  focusAreas: (
    [Distributed systems and event-driven architecture.],
    [Developer experience and tooling.],
  ),
  skills: (
    (name: "Languages", keywords: ("Scala", "Python")),
    (name: "Infra",     keywords: ("Kafka", "Kubernetes")),
  ),
  interests: (
    (name: "Music",  keywords: ("Trad", "Jazz")),
    (name: "Sport",  keywords: ("Hurling", "Climbing")),
    (name: "Travel", keywords: ("Japan", "Iceland")),
  ),
)

#alta(cv)

#pagebreak()

// Entry with empty `keywords` is skipped silently, matching `_skills`.
#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  interests: (
    (name: "Music", keywords: ("Trad", "Jazz")),
    (name: "Empty", keywords: ()),
    (name: "Sport", keywords: ("Hurling",)),
  ),
))
