// JSON Resume 1.4.0 made `publications[].type` part of the spec, with
// lowercase codes (`article`, `book`, `patent`, `thesis`, `talk`).
// Known codes map to `labels.publicationTypes` headings, matched
// case-insensitively; anything else still prints exactly as given, so
// free-text headings (`"Talks"`, `"Podcasts"`) keep working. Three
// documents:
//
//   1. Every built-in code and a free-text type.
//   2. A translated `labels.publicationTypes` table.
//   3. Code-based grouping, a partial override and the deprecated
//      `labels.articles`.

#import "../lib.typ": alta

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
    publicationTypes: (
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
// share one "Articles" subheading, and `Talk` joins `talk`. A
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
      (name: "A Book", type: "book", releaseDate: "2020"),
    ),
  ),
  labels: (articles: "Ailt", publicationTypes: (talk: "Cainteanna")),
)
