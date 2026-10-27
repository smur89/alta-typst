// Empty `url` renders an unlinked title (not a dead link); empty
// `publisher` / `releaseDate` emit no orphan line breaks; a language
// entry without a `language` name is dropped, not a panic.
//
// Page 2: empty `basics.email` / `phone` / `url` / `label` are skipped
// like absent ones — no label line, and no bare icon behind a dead
// `mailto:` / `tel:` link. Only the location entry renders in the
// contact bar.

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

#pagebreak()

#alta((
  basics: (
    name: "Jane Doe",
    label: "",
    email: "",
    phone: "",
    url: "",
    location: "Dublin, Ireland",
  ),
))
