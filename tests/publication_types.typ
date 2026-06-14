// Publications with mixed `type` values group under their own
// subheadings; entries without `type` fall into the default group
// (labels.articles). Also exercises `publisher` rendering — present
// on most entries, omitted on one to confirm the field is optional.

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  publications: (
    (
      name: "First Article",
      type: "Articles",
      publisher: "Personal Blog",
      releaseDate: "Jun 2024",
      url: "https://example.com/first",
    ),
    (
      name: "A Book",
      type: "Books",
      publisher: "Acme Press",
      releaseDate: "Mar 2025",
      url: "https://example.com/book",
    ),
    (
      name: "Conference Talk",
      type: "Talks",
      publisher: "ScalaConf",
      releaseDate: "Sep 2024",
      url: "https://example.com/talk",
      // content summary — exercises markup like emphasis
      summary: [A walk-through of _idempotent Kafka consumers_ in production.],
    ),
    (
      // type omitted → falls into labels.articles bucket
      name: "Untyped Note",
      publisher: "Personal Blog",
      releaseDate: "Jan 2024",
      url: "https://example.com/untyped",
      // plain-string summary — renders verbatim
      summary: "Short field notes on running a personal blog at scale.",
    ),
    (
      // publisher omitted → the line is skipped, only title + date render
      name: "Second Article",
      type: "Articles",
      releaseDate: "Nov 2023",
      url: "https://example.com/second",
    ),
  ),
))
