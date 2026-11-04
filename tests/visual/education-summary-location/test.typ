// JSON Resume 1.4.0 `education[].summary` (thesis, honours, other
// context) and 1.5.0 `education[].location` (string or the shared
// location dict). `summary` renders as an italic preamble after the
// date row, the same treatment as `work[].summary`; `location` sits
// on the term row, collapsed like `work[].location`. Fixture covers:
// summary + string location with score and courses, dict location,
// content-form summary, and an entry with neither.

#import "/lib.typ": alta

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
