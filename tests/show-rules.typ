// A user's show rules, written before `alta()`, restyling one part at
// a time: the name (a `title`) and the section headings (level-2
// headings) in a serif over the sans body, and the labelled parts
// (#327). The labels override the template's own text settings,
// colour included, which a rule on `heading` or `title` can't: the
// headline, the section, entry and group titles, the contact bar's
// entries, and an entry's date and location. Icons keep the theme's
// colour.

#import "../lib.typ": alta

#show selector.or(title, heading.where(level: 2)): set text(
  font: "Libertinus Serif",
)
#show <alta-headline>: set text(fill: rgb("#5b2c6f"), style: "italic")
#show <alta-section-title>: set text(fill: rgb("#1f618d"))
#show <alta-entry-title>: set text(weight: "bold")
#show <alta-group-title>: set text(fill: rgb("#b03a2e"))
#show <alta-contact>: set text(font: "New Computer Modern", weight: "regular")
#show <alta-date>: set text(fill: rgb("#b03a2e"), style: "italic")
#show <alta-location>: set text(size: 0.85em)

#alta((
  basics: (
    name: "Jane Doe",
    label: "Senior Software Engineer",
    email: "jane@example.com",
    phone: "+353 1 555 0100",
    location: "Dublin, Ireland",
  ),
  work: (
    (
      name: "Acme Corp",
      position: "Staff Engineer",
      location: "Dublin, Ireland",
      startDate: "2022-01",
      highlights: ("Led the platform team.",),
    ),
  ),
  skills: ((name: "Languages", keywords: ("Scala", "Haskell")),),
  publications: (
    (name: "Event Sourcing in Practice", type: "talk", publisher: "ScalaConf"),
  ),
))
