// Exercises the issuer-label render added by #41. Covers:
//   - multi-cert clusters render their issuer as a category-style tag
//   - singletons across distinct issuers pool into the trailing group
//     with no issuer label (no single string would describe them)
//   - clusters whose issuer is missing or empty render unlabelled
//   - `groupCertificates: false` pairs every cert with its own issuer
//
// Two renders, one fixture: bool flip across the same data so both
// branches of the new render code stay covered.

#import "../lib.typ": alta

#let cv = (
  basics: (name: "Issuer Render", email: "x@example.com"),
  certificates: (
    (name: "CKA",                       issuer: "CNCF"),
    (name: "CKAD",                      issuer: "CNCF"),
    (name: "Solutions Architect Pro",   issuer: "AWS"),
    (name: "DevOps Engineer Pro",       issuer: "AWS"),
    (name: "Lone Cert",                 issuer: "Solo Issuer A"),
    (name: "Another Lone Cert",         issuer: "Solo Issuer B"),
    (name: "Issuerless Cluster Cert 1"),                // issuer missing
    (name: "Issuerless Cluster Cert 2", issuer: ""),    // empty string
    (name: "Issuerless Cluster Cert 3", issuer: none),  // explicit none
  ),
)

#alta(cv)

#pagebreak()

#alta(cv, preferences: (groupCertificates: false))
