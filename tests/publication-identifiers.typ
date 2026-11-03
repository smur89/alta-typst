// JSON Resume 1.7.0 `publications[].identifiers`: persistent IDs keyed
// by scheme. Known schemes print under their conventional name, linked
// to a resolver where one exists (DOI, arXiv, PMID); other schemes
// print as given. Without a `url`, the title links to the first
// resolvable identifier (DOI, then arXiv, then PMID).

#import "../lib.typ": alta

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
