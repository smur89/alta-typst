// `basics.pronouns` (JSON Resume 1.4.0) renders after the name in
// smaller, regular-weight body-colour text, in parentheses. Pronouns
// are not part of the name, so `uppercaseName` leaves them as
// written. Documents exercise:
//   1. Default header — uppercase name, side portrait.
//   2. `uppercaseName: false` — name and pronouns both verbatim.
//   3. Centred header image — name and pronouns centred as one line.
//   4. Single-column layout (`columnRatio: 1`) with a long name that
//      wraps — the pronouns follow on its last line, in one piece.
//   5. Empty pronouns — renders exactly like no pronouns.
//   6. No pronouns — the baseline header.

#import "../lib.typ": alta

#let basics = (
  name: "Jane Doe",
  label: "Senior Software Engineer",
  email: "jane@example.com",
  location: "Dublin, Ireland",
  image: read("../assets/avatar-placeholder.svg", encoding: none),
)

#alta((basics: basics + (pronouns: "she/her")))

#pagebreak()

#alta(
  (basics: basics + (pronouns: "she/her")),
  preferences: (uppercaseName: false),
)

#pagebreak()

#alta(
  (basics: basics + (pronouns: "they/them")),
  preferences: (imagePosition: "center", headerTextAlign: "center"),
)

#pagebreak()

#alta(
  (
    basics: (
      name: "Alexandria Wilhelmina Fitzgerald-Montgomery",
      pronouns: "they/them",
      label: "Single-column layout, long name",
      email: "alex@example.com",
      image: none,
    ),
  ),
  preferences: (columnRatio: 1),
)

#pagebreak()

#alta((basics: basics + (pronouns: "")))

#pagebreak()

#alta((basics: basics))
