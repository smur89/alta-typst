// Each built-in accent preset rendered as its own page so a reviewer
// can flip through and check the colour against the heading rule, the
// language-rating dots, the skill-pill fills, and the link colour all
// at once. Plus a final page exercising a hand-rolled `rgb(...)` to
// confirm the `palettes` dict is purely additive — callers retain
// full freedom to pass any colour they like.

#import "../lib.typ": alta, palettes

#let sample(name, accent-key) = (
  basics: (
    name: name,
    label: "Preset: palettes." + accent-key,
    email: "preset@example.com",
    location: "Anywhere",
  ),
  skills: (
    (name: "Languages", keywords: ("Scala", "Python", "Rust")),
  ),
  languages: (
    (language: "English", fluency: "Native"),
    (language: "French", rating: 3.5),
  ),
)

#for key in palettes.keys() {
  alta(sample("Accent " + key, key), preferences: (accent: palettes.at(key)))
  pagebreak()
}

// Custom hex still works — `palettes` is a discoverability aid, not a
// gate. Anything `rgb(...)` accepts remains valid for `accent`.
#alta(
  (
    basics: (
      name: "Custom Accent",
      label: "Hand-rolled rgb(\"#B26A00\") — palettes is not a gate",
      email: "custom@example.com",
    ),
  ),
  preferences: (accent: rgb("#B26A00")),
)
