// Single-column layout achieved via existing knobs. Setting
// `columnRatio: 1` alone is enough — the layout merges every section
// from both `leftColumnSections` and `rightColumnSections` into a
// single full-width stream (left-then-right order), so callers don't
// need to redistribute the defaults. See the README's "Single-column
// layout" section.

#import "../lib.typ": alta

#let cv = (
  basics: (
    name: "Jane Doe",
    label: "Senior Engineer",
    email: "jane@example.com",
    phone: "+353 1 555 0100",
    location: "Dublin",
    // Drop the portrait so the header is fully text-only.
    image: none,
  ),
  work: (
    (
      name: "Acme Corp",
      position: "Senior Engineer",
      startDate: "Jan 2022",
      highlights: ([Led the migration of the platform.],),
    ),
  ),
  skills: (
    (name: "Languages", keywords: ("Scala", "Haskell")),
  ),
  languages: (
    (language: "English", fluency: "Native"),
  ),
  education: (
    (institution: "Example University", studyType: "M.Sc."),
  ),
)

// First page: `columnRatio: 1` is sufficient — every section from the
// default left + right arrays streams in left-then-right order.
#alta(cv, preferences: (columnRatio: 1))

#pagebreak()

// Second page: explicit override re-orders the stream. The arrays are
// still concatenated in left-then-right order, so callers can use
// either array to express their preferred ordering.
#alta(cv, preferences: (
  columnRatio: 1,
  leftColumnSections: ("work", "education"),
  rightColumnSections: ("skills", "languages"),
))

#pagebreak()

// Third page: partial `columnRatio` with an empty `rightColumnSections`.
// Exercises the "collapse the grid to avoid a zero-width right cell"
// branch — the left column is rendered full-width even though the ratio
// is less than 1, because there is no right content to allocate space
// for.
#alta(cv, preferences: (
  columnRatio: 0.6,
  rightColumnSections: (),
))
