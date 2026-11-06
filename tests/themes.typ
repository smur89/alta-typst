// Each built-in theme rendered as its own page so a reviewer can flip
// through and check its colours against the name, the tagline, the
// heading and its rule, the language-rating dots, the skill-tag
// fills and the organisation line all at once. Then a page setting
// one colour over a theme, to confirm it changes only the role it
// names, and one adding a show rule on a part over both, which wins.
// Each page's theme is a scoped `altacv`.

#import "../lib.typ": alta, altacv, themes

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
  [
    #show: altacv.with(theme: themes.at(key))
    #alta(sample("Theme " + key, key))
  ]
  pagebreak()
}

// A theme as the default, with one role changed.
#[
  #show: altacv.with(
    theme: themes.navy
      + (colours: (..themes.navy.colours, heading-rule: rgb("#E7D192"))),
  )
  #alta(sample("Theme navy, gold rule", "navy"))
]
#pagebreak()

// A theme, a role over it, and a show rule over both: the body turns
// black, the section titles navy, the rules stay gold.
#[
  #show: altacv.with(
    theme: themes.altacv + (colours: (..themes.altacv.colours, body: black)),
  )
  #show <alta-section-title>: set text(fill: themes.navy.colours.heading)
  #alta(sample("Theme altacv, black body, navy titles", "altacv"))
]

#pagebreak()

// A theme of the caller's own, setting only some tokens: a serif
// typeface, a smaller headline and ` | ` between facts (education's
// area and score). Everything else, colours included, is the default
// theme's.
#show: altacv.with(
  theme: (
    font: "Libertinus Serif",
    type: (headline: (size: 1.2)),
    separator: (facts: " | "),
  ),
)
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
)
