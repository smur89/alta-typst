// `preferences.density` scales every spacing em-token uniformly so a
// single knob trades vertical breathing room for fit-on-one-page.
// Three pages exercise each preset against the same data; visual diff
// against the default ("comfortable") confirms the multiplier reaches
// section headings, divider rules, par.spacing, and the in-section
// block above/below tokens.

#import "../lib.typ": alta

#let cv = (
  basics: (
    name: "Jane Doe",
    label: "Senior Software Engineer",
    summary: [Backend engineer; the summary block exercises the
      pre/post `v()` gaps that flank it.],
    email: "jane@example.com",
    phone: "+353 1 555 0100",
    location: "Dublin, Ireland",
  ),
  work: (
    (
      name: "Acme Corp",
      position: "Senior Software Engineer",
      location: "Dublin, Ireland",
      startDate: "Jan 2022",
      highlights: ([Led the migration.], [Designed the platform.]),
    ),
    (
      name: "Foo Ltd",
      position: "Software Engineer",
      startDate: "Jan 2018",
      endDate: "Dec 2021",
      highlights: ([Shipped the thing.],),
    ),
  ),
  skills: (
    (name: "Languages", keywords: ("Scala", "Python")),
    (name: "Infra",     keywords: ("Kafka", "AWS", "Kubernetes")),
  ),
  languages: (
    (language: "English", fluency: "Native"),
    (language: "Irish",   fluency: "Professional Working"),
  ),
  education: (
    (institution: "Example U", studyType: "B.Sc.", endDate: "2017"),
  ),
  certificates: (
    (name: "CKA", issuer: "CNCF"),
  ),
)

// 1. Compact — em spacing tokens × 0.85. Tighter than the default.
#alta(cv, preferences: (density: "compact"))

#pagebreak()

// 2. Comfortable — em spacing tokens × 1.0. The default; explicit
//    here so the regression is anchored even if the default changes.
#alta(cv, preferences: (density: "comfortable"))

#pagebreak()

// 3. Spacious — em spacing tokens × 1.15. Roomier than the default.
#alta(cv, preferences: (density: "spacious"))
