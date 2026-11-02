// LinkedIn `fluency` strings scale to `preferences.maxRating`, rounded
// to the nearest half, so they fit any dot count instead of
// overflowing a smaller scale. Numeric `rating` is used as given.
// Pages: the default 5-dot scale, then 4 and 6 dots.

#import "../lib.typ": alta

#let cv(name) = (
  basics: (name: name, email: "jane@example.com"),
  languages: (
    (language: "English", fluency: "Native"),
    (language: "German", fluency: "Full Professional"),
    (language: "Irish", fluency: "Professional Working"),
    (language: "French", fluency: "Limited Working"),
    (language: "Italian", fluency: "Elementary"),
    (language: "Spanish", rating: 2),
  ),
)

#alta(cv("Five Dots"))

#pagebreak()

#alta(cv("Four Dots"), preferences: (maxRating: 4))

#pagebreak()

#alta(cv("Six Dots"), preferences: (maxRating: 6))
