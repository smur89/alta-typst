// `education[].courses` (JSON Resume) renders as a row of pill tags
// below the entry — same treatment as `skills[].keywords` and
// `projects[].keywords`. Covers an entry with courses + score, an
// entry with courses but no score, and an entry with no courses
// (should render unchanged from the pre-courses baseline). An
// explicitly empty `courses: ()` is also silently skipped.

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  education: (
    (
      institution: "Example University",
      studyType: "M.Sc. in Computer Science",
      startDate: "2017",
      endDate: "2019",
      score: "Distinction",
      courses: ("Distributed Systems", "Type Theory", "Concurrency"),
    ),
    (
      institution: "Example University",
      studyType: "B.Sc. in Computer Science",
      startDate: "2014",
      endDate: "2017",
      courses: ("Algorithms", "Operating Systems", "Compilers", "Databases"),
    ),
    (
      // No `courses` key — entry renders without the pill row.
      institution: "Trinity College Dublin",
      area: "Mathematics",
      startDate: "2011",
      endDate: "2014",
    ),
    (
      // Explicit empty `courses` — also skipped, no orphan whitespace.
      institution: "Open University",
      studyType: "Foundation Year",
      startDate: "2010",
      endDate: "2011",
      courses: (),
    ),
  ),
))
