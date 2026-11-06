// What a CV leaves out, or leaves empty, renders nothing: no orphan
// heading, line break, icon or dead link. Documents:
//
//   1. Only `basics`: every other top-level key is omitted, so the
//      template skips those sections.
//   2. Every section present but empty: each renderer short-circuits,
//      so the document is only the header.
//   3. Empty fields: an empty `url` renders an unlinked title (not a
//      dead link); empty `publisher` / `releaseDate` emit no orphan
//      line breaks; a language entry without a `language` name is
//      dropped, not a panic.
//   4. Empty `basics.email` / `phone` / `url` / `label` are skipped
//      like absent ones: no label line, and no bare icon behind a dead
//      `mailto:` / `tel:` link. Only the location renders in the
//      contact bar.
//
// Certificates that all lack a `name` are in tests/certificates.typ.

#import "../lib.typ": alta

#alta((
  basics: (
    name: "Jane Doe",
    label: "Software Engineer",
    email: "jane@example.com",
  ),
))

#pagebreak()

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  custom: (altacv: (focusAreas: ())),
  work: (),
  volunteer: (),
  skills: (),
  languages: (),
  education: (),
  certificates: (),
  interests: (),
  publications: (),
))

#pagebreak()

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
      custom: (altacv: (url: "")),
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
