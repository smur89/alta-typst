// Recognised `languages[].fluency` values render as dots; unknown ones
// as a text note. Page 2 repeats a few on 4- and 6-dot scales, which
// the values scale to.

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  languages: (
    // LinkedIn terms keep their counts, with or without the
    // "proficiency" suffix LinkedIn's labels carry.
    (language: "English", fluency: "Native"),
    (language: "Irish", fluency: "Professional working proficiency"),
    (language: "Manx", fluency: "Native or bilingual proficiency"),
    // Common words, including the schema's own examples.
    (language: "French", fluency: "Fluent"),
    (language: "German", fluency: "Upper Intermediate"),
    (language: "Spanish", fluency: "Conversational"),
    (language: "Dutch", fluency: "Beginner"),
    // CEFR levels.
    (language: "Italian", fluency: "C1"),
    (language: "Portuguese", fluency: "B1"),
    (language: "Polish", fluency: "A2"),
    // Case and surrounding spaces don't matter.
    (language: "Welsh", fluency: " native "),
    (language: "Breton", fluency: "INTERMEDIATE"),
    // Unknown value: text note, no dots.
    (language: "Japanese", fluency: "Learning"),
  ),
))

#pagebreak()

#let scaled = (
  (language: "English", fluency: "Native"),
  (language: "French", fluency: "Fluent"),
  (language: "Irish", fluency: "Professional Working"),
  (language: "Italian", fluency: "C2"),
)

#alta(
  (basics: (name: "Four Dots", email: "jane@example.com"), languages: scaled),
  preferences: (maxRating: 4),
)

#pagebreak()

#alta(
  (basics: (name: "Six Dots", email: "jane@example.com"), languages: scaled),
  preferences: (maxRating: 6),
)
