// Language ratings: integer, fractional (half-dot), boundary values
// (0 and the configured max), fluency-string fallback, and a custom
// `preferences.max-rating` for non-5 scales (CEFR's 6 levels here).

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
