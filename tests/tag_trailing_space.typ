// Exercises tag() at row boundaries. The `trailing: false` parameter
// drops the inter-tag gap that would otherwise sit after the pill —
// useful when callers want exact horizontal control composing tags in
// custom layouts. With long keyword lists Typst wraps onto multiple
// rows; the last tag overall (and incidentally any tag landing at a
// soft row break) renders without a trailing gutter. Default behaviour
// (trailing: true) is unchanged.

#import "../lib.typ": alta, tag

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  projects: (
    (
      // Long keyword list to force wrapping across multiple rows
      // inside the right column.
      name: "Polyglot",
      description: "Tag-wrapping stress test",
      keywords: (
        "Scala", "Python", "Rust", "Go", "TypeScript", "Kotlin", "Java",
        "Haskell", "OCaml", "Clojure", "Elixir", "Ruby",
      ),
    ),
  ),
  certificates: (
    // Two issuers with multiple certs each → tags wrap inside each
    // group. groupCertificates defaults to true.
    (name: "AWS Solutions Architect", issuer: "Amazon Web Services"),
    (name: "AWS DevOps Engineer",     issuer: "Amazon Web Services"),
    (name: "AWS Security Specialty",  issuer: "Amazon Web Services"),
    (name: "CKA",                     issuer: "CNCF"),
    (name: "CKAD",                    issuer: "CNCF"),
  ),
))

// Custom-layout spot check: trailing: false on the final tag yields a
// row that ends flush with the last pill, no trailing gutter.
#tag("alpha")
#tag("beta")
#tag("gamma", trailing: false)
