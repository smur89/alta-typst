// JSON Resume `publications` grouped by `type`, with each group's
// heading and icon. Documents:
//
//   1. Mixed `type` values group under their own subheadings; entries
//      without `type` fall into the default group (labels.articles).
//      Also exercises `publisher` rendering — present on most entries,
//      omitted on one to confirm the field is optional.
//   2. JSON Resume 1.4.0 made `type` part of the spec, with lowercase
//      codes (`article`, `book`, `patent`, `thesis`, `talk`). Known
//      codes map to `labels.publication-types` headings, matched
//      case-insensitively; anything else still prints exactly as given,
//      so free-text headings (`"Talks"`, `"Podcasts"`) keep working.
//      Every built-in code and a free-text type.
//   3. The same with a translated `labels.publication-types` table.
//   4. Code-based grouping, a partial override and the deprecated
//      `labels.articles`.
//   5. `preferences.publication-icons`: a custom type, matched
//      case-insensitively, and a remapped built-in. Precedence over the
//      deprecated `labels.publication-icons` is pinned in
//      tests/unit/canonical.typ.

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

#pagebreak()

#let pubs = (
  (name: "An Article", type: "article", releaseDate: "2024"),
  (name: "A Book", type: "book", releaseDate: "2023"),
  (name: "A Patent", type: "patent", releaseDate: "2022"),
  (name: "A Thesis", type: "thesis", releaseDate: "2021"),
  (name: "A Talk", type: "talk", publisher: "ScalaConf", releaseDate: "2020"),
  (name: "A Podcast", type: "Podcasts", releaseDate: "2019"),
)

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  publications: pubs,
))

#pagebreak()

#alta(
  (basics: (name: "Jane Doe", email: "jane@example.com"), publications: pubs),
  labels: (
    publication-types: (
      article: "Artikel",
      book: "Bücher",
      patent: "Patente",
      thesis: "Abschlussarbeiten",
      talk: "Vorträge",
    ),
  ),
)

#pagebreak()

// Grouping keys on the code: untyped entries and `type: "article"`
// share one "Articles" subheading, and `Talk` and ` talk ` join `talk`. A
// translation can override a single code (the rest stay English), and
// the deprecated `labels.articles` still heads the `article` group.
#alta(
  (
    basics: (name: "Jane Doe", email: "jane@example.com"),
    publications: (
      (name: "Untyped Note", releaseDate: "2024"),
      (name: "An Article", type: "article", releaseDate: "2023"),
      (name: "A Talk", type: "talk", releaseDate: "2022"),
      (name: "Another Talk", type: "Talk", releaseDate: "2021"),
      (name: "A Padded Talk", type: " talk ", releaseDate: "2021"),
      (name: "A Book", type: "book", releaseDate: "2020"),
    ),
  ),
  labels: (articles: "Ailt", publication-types: (talk: "Cainteanna")),
)

#pagebreak()

#alta(
  (
    basics: (name: "Jane Doe", email: "jane@example.com"),
    publications: (
      (name: "An Article", releaseDate: "2024-06"),
      (name: "A Book", type: "book", releaseDate: "2025-03"),
      (name: "A Talk", type: "talk", releaseDate: "2024-09"),
      (name: "An Episode", type: "Podcast", releaseDate: "2025-01"),
    ),
  ),
  labels: (publication-types: (podcast: "Podcasts")),
  preferences: (publication-icons: (Podcast: "microphone", talk: "newspaper")),
)
