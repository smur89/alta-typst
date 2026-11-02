// `certificates[].issuer` renders as the accent line under each
// certificate's name; a missing or empty issuer leaves the line out.
// The second render sets the deprecated `groupCertificates: false`,
// which is still accepted and has no effect, so both pages match.

#import "../lib.typ": alta

#let cv = (
  basics: (name: "Issuer Render", email: "x@example.com"),
  certificates: (
    (name: "CKA", issuer: "CNCF"),
    (name: "CKAD", issuer: "CNCF"),
    (name: "Solutions Architect Pro", issuer: "AWS"),
    (name: "DevOps Engineer Pro", issuer: "AWS"),
    (name: "Lone Cert", issuer: "Solo Issuer A"),
    (name: "Another Lone Cert", issuer: "Solo Issuer B"),
    (name: "Issuerless Cluster Cert 1"), // issuer missing
    (name: "Issuerless Cluster Cert 2", issuer: ""), // empty string
    (name: "Issuerless Cluster Cert 3", issuer: none), // explicit none
  ),
)

#alta(cv)

#pagebreak()

#alta(cv, preferences: (groupCertificates: false))
