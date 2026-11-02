// JSON Resume 1.7.0 `publications[].volume`, `issue` and `pages` form a
// journal-style tail after the publisher: `Publisher 12(3), 45–67`.
// Each part is optional and takes its punctuation with it; a hyphen or
// run of hyphens in `pages` becomes one en dash. With no publisher the
// tail stands alone.

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  publications: (
    (
      name: "Full Citation",
      publisher: "J. Systems",
      volume: "12",
      issue: "3",
      pages: "45-67",
    ),
    (name: "Volume Only", publisher: "J. Systems", volume: "12"),
    (name: "Issue Only", publisher: "J. Systems", issue: "3"),
    (name: "Pages Only", publisher: "J. Systems", pages: "101--118"),
    (
      name: "Volume And Pages",
      publisher: "J. Systems",
      volume: "7",
      pages: "9",
    ),
    (name: "No Publisher", volume: "4", issue: "1", pages: "1-20"),
    (
      name: "Empty Parts",
      publisher: "J. Systems",
      volume: "",
      issue: "",
      pages: "",
    ),
  ),
))
