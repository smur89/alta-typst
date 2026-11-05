// `preferences.publication-icons`: a custom type, matched
// case-insensitively, and a remapped built-in. Precedence over the
// deprecated `labels.publication-icons` is pinned in
// tests/unit/canonical.typ.

#import "../lib.typ": alta

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
