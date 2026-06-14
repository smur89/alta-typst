// `preferences.leftColumnSections` and `preferences.rightColumnSections`
// control which sections render in which column, and in what order.
// Sections are placeable in either column; section renderers are
// width-agnostic so they adapt to wherever they land.
//
// Four documents exercise the API surface:
//   1. Reversed right-column order (default left column).
//   2. Subset (only `skills` + `education` on the right).
//   3. Inverted layout — `work` on the right, side-panel sections on
//      the left, with `column-ratio` flipped to give the side panel
//      a narrower left column.
//   4. Both columns empty — only the header renders.

#import "../lib.typ": alta

#let cv = (
  basics: (name: "Jane Doe", email: "jane@example.com"),
  focusAreas: ([Item one.], [Item two.]),
  work: (
    (
      name: "Acme",
      position: "Engineer",
      startDate: "Jan 2022",
      highlights: ([Did work.],),
    ),
  ),
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

// 1. Reversed right-column order; left stays at its default (work).
#alta(cv, preferences: (
  rightColumnSections: ("publications", "certificates", "education", "languages", "skills", "focusAreas"),
))

#pagebreak()

// 2. Subset on the right.
#alta(cv, preferences: (
  rightColumnSections: ("skills", "education"),
))

#pagebreak()

// 3. Inverted layout: side-panel sections move to the (now narrower)
//    left column, work moves to the (now wider) right column.
//    `columnRatio` lives alongside the section arrays in preferences.
#alta(cv, preferences: (
  columnRatio: 0.35,
  leftColumnSections: ("focusAreas", "skills", "languages", "education", "certificates"),
  rightColumnSections: ("work", "publications"),
))

#pagebreak()

// 4. Both columns empty — header only.
#alta(cv, preferences: (
  leftColumnSections: (),
  rightColumnSections: (),
))
