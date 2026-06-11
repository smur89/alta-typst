// preferences.sectionOrder controls the right-column rendering order
// and which sections render at all. Three documents:
//   1. Reversed default order.
//   2. Subset (only skills + education).
//   3. Empty array — side panel renders nothing.

#import "../lib.typ": alta

#let cv = (
  basics: (name: "Jane Doe", email: "jane@example.com"),
  focusAreas: ([Item one.], [Item two.]),
  skills: ((name: "Lang", keywords: ("Scala",)),),
  languages: ((language: "English", fluency: "Native"),),
  education: (
    (institution: "Example U", studyType: "B.Sc.", endDate: "2017"),
  ),
  certificates: ((name: "CKA", issuer: "CNCF"),),
  publications: (
    (name: "Article", releaseDate: "Jun 2024", url: "https://example.com"),
  ),
)

#alta(cv, preferences: (
  sectionOrder: ("publications", "certificates", "education", "languages", "skills", "focusAreas"),
))

#pagebreak()

#alta(cv, preferences: (
  sectionOrder: ("skills", "education"),
))

#pagebreak()

#alta(cv, preferences: (
  sectionOrder: (),
))
