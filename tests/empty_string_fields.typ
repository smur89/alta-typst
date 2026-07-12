// Empty-string and absent optional fields on the `styled-link`
// sections. Empty `url` must render an unlinked title (not a dead
// link); empty `publisher` / `releaseDate` must not emit orphan
// line breaks; a language entry without a `language` name is
// dropped, matching the filter-first pattern of the other sections.

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  projects: (
    (
      name: "Linkless Project",
      url: "",
      description: "Empty url renders the title unlinked.",
    ),
  ),
  awards: (
    (
      title: "Linkless Award",
      url: "",
      awarder: "Committee",
    ),
  ),
  publications: (
    (
      name: "Sparse Publication",
      url: "",
      publisher: "",
      releaseDate: "",
    ),
  ),
  languages: (
    (language: "English", fluency: "Native"),
    // No `language` name — dropped, not a panic.
    (fluency: "Elementary"),
  ),
))
