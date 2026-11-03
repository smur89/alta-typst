// JSON Resume 1.6.0 made `projects[].summary` the preferred field and
// kept `description` as a deprecated alias: `summary` wins when both
// are set, and an empty `summary` falls through to `description` (the
// same precedence `work[]` uses). Fixture covers: summary only,
// description only (legacy), both (summary wins), empty summary
// (falls back), and content-form summary.

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  projects: (
    (
      name: "Summary Only",
      summary: "Event-sourced ledger for a payments start-up.",
      startDate: "2024",
    ),
    (
      name: "Description Only",
      description: "Legacy spelling, still rendered.",
      startDate: "2023",
    ),
    (
      name: "Both Set",
      summary: "Summary wins.",
      description: "Description is ignored when summary is present.",
      startDate: "2022",
    ),
    (
      name: "Empty Summary",
      summary: "",
      description: "Falls back to description.",
      startDate: "2021",
    ),
    (
      name: "Content Summary",
      summary: [Markup _renders_ too.],
      startDate: "2020",
    ),
  ),
))
