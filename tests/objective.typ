// JSON Resume 1.4.0's root `objective` renders in italics in the
// header, under the tagline (`basics.label`), with `basics.summary`
// below the header when set. Pages: objective with a summary,
// objective alone, and an objective given as content.

#import "../lib.typ": alta

#let basics = (
  name: "Jane Doe",
  label: "Software Engineer",
  email: "jane@example.com",
)
#let work = (
  (name: "Acme Corp", position: "Engineer", startDate: "2022-01"),
)

#alta((
  basics: basics
    + (summary: "Backend engineer with eight years' experience in payments."),
  objective: "Seeking a senior backend role in climate tech.",
  work: work,
))

#pagebreak()

#alta((
  basics: basics,
  objective: "Seeking a senior backend role in climate tech.",
  work: work,
))

#pagebreak()

#alta((
  basics: basics,
  objective: [Seeking a *senior backend* role in climate tech.],
  work: work,
))
