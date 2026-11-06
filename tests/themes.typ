// Each built-in theme rendered as its own page so a reviewer can flip
// through and check its colours against the name, the tagline, the
// heading and its rule, the language-rating dots, the skill-tag
// fills and the organisation line all at once. Then a page setting
// `colours` over a theme, to confirm it changes only the roles it
// names, and one adding a show rule on a part over both, which wins.

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
    (language: "French", custom: (altacv: (rating: 3.5))),
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
    colours: (heading-rule: rgb("#E7D192")),
  ),
)
#pagebreak()

// A theme, a role over it, and a show rule over both: the body turns
// black, the section titles navy, the rules stay gold.
#{
  show <alta-section-title>: set text(fill: themes.navy.colours.heading)
  alta(
    sample("Theme altacv, black body, navy titles", "altacv"),
    preferences: (theme: themes.altacv, colours: (body: black)),
  )
}

#pagebreak()

// A theme of the caller's own, setting only some tokens: a serif
// typeface, a smaller headline and ` | ` between facts (education's
// area and score). Everything else, colours included, is the default
// theme's.
#alta(
  (
    basics: (
      name: "Own theme: serif, smaller headings",
      label: "A partial theme",
    ),
    work: (
      (
        position: "Engineer",
        name: "Acme",
        startDate: "2020-01",
        location: "Cork, Ireland",
      ),
    ),
    education: (
      (
        institution: "UCC",
        studyType: "M.Sc.",
        area: "Engineering",
        score: "First class",
        startDate: "2018",
        endDate: "2019",
      ),
    ),
  ),
  preferences: (
    theme: (
      font: "Libertinus Serif",
      type: (headline: (size: 1.2)),
      separator: (facts: " | "),
    ),
  ),
)
