// A heading font through a show rule before `alta()`: the name (a
// `title`) and the section headings (level-2 headings) in a serif
// over the sans body. The label, entry titles and contact bar stay in
// `font`.

#import "../lib.typ": alta

#show selector.or(title, heading.where(level: 2)): set text(
  font: "Libertinus Serif",
)

#alta((
  basics: (
    name: "Jane Doe",
    label: "Senior Software Engineer",
    email: "jane@example.com",
  ),
  work: (
    (
      name: "Acme Corp",
      position: "Staff Engineer",
      startDate: "2022-01",
      highlights: ("Led the platform team.",),
    ),
  ),
  skills: ((name: "Languages", keywords: ("Scala", "Haskell")),),
))
