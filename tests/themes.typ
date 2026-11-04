// Each built-in theme rendered as its own page so a reviewer can flip
// through and check its colours against the name, the headline, the
// heading and its rule, the language-rating dots, the skill-pill
// fills and the organisation line all at once. Plus a final page
// setting `colours` over a theme, to confirm it changes only the
// roles it names.

#import "../lib.typ": alta, themes

#let sample(name, theme-key) = (
  basics: (
    name: name,
    label: "Preset: themes." + theme-key,
    email: "preset@example.com",
    location: "Anywhere",
  ),
  work: (
    (position: "Engineer", name: "Acme", startDate: "2020-01"),
  ),
  skills: (
    (name: "Languages", keywords: ("Scala", "Python", "Rust")),
  ),
  languages: (
    (language: "English", fluency: "Native"),
    (language: "French", rating: 3.5),
  ),
)

#for key in themes.keys() {
  alta(sample("Theme " + key, key), preferences: (theme: themes.at(key)))
  pagebreak()
}

// A theme as the default, with one role changed.
#alta(
  sample("Theme navy, gold rule", "navy"),
  preferences: (
    theme: themes.navy,
    colours: (headingRule: rgb("#E7D192")),
  ),
)
