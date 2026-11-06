// LinkedIn `fluency` strings scale to `preferences.max-rating`, rounded
// to the nearest half, so they fit any dot count instead of
// overflowing a smaller scale. A numeric `custom.altacv.rating` is used
// as given.
// Fluency matches case-insensitively (Portuguese: lowercase, padded).
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
    (language: "Spanish", custom: (altacv: (rating: 2))),
    (language: "Portuguese", fluency: " professional working "),
  ),
)

#alta(cv("Five Dots"))

#pagebreak()

#alta(cv("Four Dots"), preferences: (max-rating: 4))

#pagebreak()

#alta(cv("Six Dots"), preferences: (max-rating: 6))
