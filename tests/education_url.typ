// Exercises `education[].url` — when present, the institution name
// renders as an accent-bold link. Covers entries with a URL, without
// a URL, and the edge cases of an empty institution + URL pair
// (skipped as a link target) and the bare minimum schema.

#import "../lib.typ": alta

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
      // Falls back to `area` when `studyType` is missing.
      institution: "Trinity Hall",
      url: "https://example.com/trinity",
      area: "Computer Science",
      startDate: "2010",
      endDate: "2014",
    ),
    (
      // URL with empty institution — the link is suppressed (no
      // clickable empty span) but the entry still renders its title.
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
