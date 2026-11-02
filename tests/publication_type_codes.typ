// JSON Resume 1.4.0 made `publications[].type` part of the spec, with
// lowercase codes (`article`, `book`, `patent`, `thesis`, `talk`).
// Known codes map to `labels.publicationTypes` headings, matched
// case-insensitively; anything else still prints exactly as given, so
// free-text headings (`"Talks"`, `"Podcasts"`) keep working. Two
// documents:
//
//   1. Every built-in code and a free-text type.
//   2. A translated `labels.publicationTypes` table.

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
