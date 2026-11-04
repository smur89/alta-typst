// `preferences.headingFont`: the name and section headings in a serif
// over the sans body, as LaTeX AltaCV pairs Roboto Slab with Lato.
// Entry titles, the label and the contact bar stay in `font`.

#import "../lib.typ": alta

#alta(
  (
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
  ),
  preferences: (headingFont: "Libertinus Serif"),
)
