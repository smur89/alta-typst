// An entry's fields in JSON Resume `publications`. Documents:
//
//   1. `authors`, the CV owner in bold. Covers several authors with the
//      owner in the middle, a sole author, a list without the owner, a
//      differently cased and padded owner, and empty / non-string
//      entries, which are skipped.
//   2. The owner bolded under `preferences.owner-names` too: initials
//      and a former name.
//   3. JSON Resume 1.7.0 `volume`, `issue` and `pages` form a
//      journal-style tail after the publisher: `Publisher 12(3),
//      45–67`. Each part is optional and takes its punctuation with it;
//      a hyphen or run of hyphens in `pages` becomes one en dash. With
//      no publisher the tail stands alone.
//   4. JSON Resume 1.7.0 `identifiers`: persistent IDs keyed by scheme.
//      Known schemes print under their conventional name, linked to a
//      resolver where one exists (DOI, arXiv, PMID); other schemes
//      print as given. Without a `url`, the title links to the first
//      resolvable identifier (DOI, then arXiv, then PMID).

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  publications: (
    (
      name: "Idempotent Consumers in Production",
      authors: ("Sam Smith", "Jane Doe", "Alex Ng"),
      publisher: "ScalaConf",
    ),
    (name: "Sole Author", authors: ("Jane Doe",)),
    (name: "Without The Owner", authors: ("Sam Smith", "Alex Ng")),
    (name: "Different Case", authors: (" jane doe ", "Sam Smith")),
    (name: "Unusable Entries", authors: ("", 42, "Sam Smith")),
    (name: "No Authors"),
  ),
))

#pagebreak()

#alta(
  (
    basics: (name: "Jane Doe"),
    publications: (
      (name: "By Initials", authors: ("Sam Smith", "J. Doe")),
      (name: "Under A Former Name", authors: ("Jane Smith", "Alex Ng")),
    ),
  ),
  preferences: (owner-names: ("J. Doe", "Jane Smith")),
)

#pagebreak()

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

#pagebreak()

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  publications: (
    // No url: title → doi.org; both IDs listed.
    (
      name: "Idempotent Consumers in Production",
      publisher: "ScalaConf",
      releaseDate: "2024-09",
      identifiers: (doi: "10.1000/182", arxiv: "2101.00001"),
    ),
    // No url, arXiv only: title → arxiv.org.
    (name: "A Preprint", identifiers: (arxiv: "2312.00002")),
    // A url wins for the title; the DOI is still listed.
    (
      name: "Linked Elsewhere",
      url: "https://example.com/paper",
      identifiers: (doi: "10.1000/999"),
    ),
    // ISBN (no resolver), PMID and an unknown scheme printed as given.
    (
      name: "A Book",
      identifiers: (isbn: "978-3-7502-4718-5", pmid: "12345678", ssrn: "4567"),
    ),
    // Empty and non-string values are skipped; nothing renders.
    (name: "No Usable IDs", identifiers: (doi: "", arxiv: 42)),
  ),
))
