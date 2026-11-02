// `publications[].authors`, the CV owner in bold. Covers several
// authors with the owner in the middle, a sole author, a list without
// the owner, a differently cased and padded owner, and empty /
// non-string entries, which are skipped.

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
