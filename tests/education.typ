// JSON Resume `education`. Documents:
//
//   1. `area` beside `studyType`: it leads the score line
//      (`Engineering · Distinction`), stands alone there without a
//      score, and is the title when `studyType` is missing (not
//      repeated below).
//   2. `courses` render as one line joined with ` · ` at the end of the
//      entry, as `projects[].keywords` do: with a score, without one,
//      no `courses` key, and an explicitly empty `courses: ()`, which
//      is silently skipped.
//   3. JSON Resume 1.4.0 `summary` (thesis, honours, other context) and
//      1.5.0 `location` (string or the shared location dict). `summary`
//      renders as an italic preamble after the date row, the same
//      treatment as `work[].summary`; `location` sits on the term row,
//      collapsed like `work[].location`. Covers summary + string
//      location with score and courses, dict location, content-form
//      summary, and an entry with neither.
//   4. `url`: when present, the institution name renders as an
//      accent-bold link. Covers entries with a URL, without one, an
//      empty institution + URL pair (skipped as a link target), an
//      empty-string `url`, and the bare minimum schema.

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe"),
  education: (
    (
      institution: "Trinity College Dublin",
      studyType: "Bachelor",
      area: "Engineering",
      score: "Distinction",
      startDate: "2014",
      endDate: "2018",
    ),
    (
      institution: "University College Cork",
      studyType: "Master",
      area: "Data Science",
      startDate: "2018",
      endDate: "2019",
    ),
    (
      institution: "Open University",
      area: "Philosophy",
      score: "Merit",
      courses: ("Logic", "Ethics"),
    ),
  ),
))

#pagebreak()

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
      // No `courses` key — entry renders without the tag row.
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

#pagebreak()

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  education: (
    (
      institution: "Trinity College Dublin",
      studyType: "BSc Computer Science",
      startDate: "2014",
      endDate: "2018",
      location: "Dublin, Ireland",
      summary: "Thesis on idempotent consumers in event-driven systems.",
      score: "First-class honours",
      courses: ("Distributed Systems", "Compilers"),
    ),
    (
      institution: "ETH Zürich",
      studyType: "MSc Computer Science",
      startDate: "2018",
      endDate: "2020",
      location: (city: "Zürich", countryCode: "CH"),
    ),
    (
      institution: "Open University",
      studyType: "Certificate",
      startDate: "2021",
      summary: [Part-time, _alongside_ full-time work.],
    ),
    (
      institution: "No Extras",
      studyType: "Diploma",
      startDate: "2012",
    ),
  ),
))

#pagebreak()

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  education: (
    (
      // Full entry with URL — institution should render as a link
      // preserving the accent-bold style.
      institution: "Example University",
      url: "https://example.edu",
      studyType: "M.Sc. in Computer Science",
      startDate: "2017",
      endDate: "2019",
      score: "Distinction",
    ),
    (
      // No URL — institution renders as plain accent-bold text.
      institution: "Other Institute",
      studyType: "B.Sc. in Mathematics",
      startDate: "2014",
      endDate: "2017",
    ),
    (
      // An empty `studyType` falls back to `area` like a missing one.
      institution: "Night School",
      studyType: "",
      area: "Statistics",
      startDate: "2008",
    ),
    (
      // Falls back to `area` when `studyType` is missing.
      institution: "Trinity Hall",
      url: "https://example.com/trinity",
      area: "Computer Science",
      startDate: "2010",
      endDate: "2014",
    ),
    (
      // URL with empty institution — no institution line (and no
      // blank gap for one), but the entry still renders its title.
      institution: "",
      url: "https://example.com/empty",
      studyType: "Diploma",
      startDate: "2009",
      endDate: "2010",
    ),
    (
      // Empty-string `url` is treated as absent — institution
      // renders as plain accent-bold text, not as a dead link.
      institution: "No-URL College",
      url: "",
      studyType: "Higher Diploma",
      startDate: "2008",
      endDate: "2009",
    ),
  ),
))
