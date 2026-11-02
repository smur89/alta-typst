// `certificates[].issuer` renders in bold accent on each
// certificate's term row; a missing, empty or `none` issuer leaves it
// out.

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
    (name: "Issuerless Cert 1"), // issuer missing
    (name: "Issuerless Cert 2", issuer: ""), // empty string
    (name: "Issuerless Cert 3", issuer: none), // explicit none
  ),
)

#alta(cv)
