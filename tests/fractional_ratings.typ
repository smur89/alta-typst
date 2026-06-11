// Language ratings: integer, fractional (half-dot), boundary values
// (0 and _max_rating), and fluency-string fallback.

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
