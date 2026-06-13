// Language ratings: integer, fractional (half-dot), boundary values
// (0 and the configured max), fluency-string fallback, and a custom
// `preferences.maxRating` for non-5 scales (CEFR's 6 levels here).

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  languages: (
    (language: "English",   rating: 5),
    (language: "French",    rating: 4.5),
    (language: "Spanish",   rating: 2.5),
    (language: "Portuguese", rating: 0),
    (language: "German",    fluency: "Elementary"),
    (language: "Italian",   fluency: "Native"),
  ),
))

#pagebreak()

// CEFR-style 6-level scale. Fluency strings are anchored to LinkedIn's
// 0–5 scale, so this page uses numeric ratings exclusively — covering
// the new maximum (6) and a fractional value above the default cap.
#alta(
  (
    basics: (name: "Jean Dupont", email: "jean@example.com"),
    languages: (
      (language: "French",  rating: 6),
      (language: "English", rating: 5.5),
      (language: "German",  rating: 4),
      (language: "Spanish", rating: 2),
    ),
  ),
  preferences: (maxRating: 6),
)
