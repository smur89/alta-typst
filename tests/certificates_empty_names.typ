// All certificates have empty / missing `name`. The Certifications
// section should be suppressed entirely — no orphan heading with no
// items below it. Also sets the deprecated `groupCertificates: false`,
// which is where an earlier regression lived.

#import "../lib.typ": alta

#alta(
  (
    basics: (name: "All Names Empty", email: "x@example.com"),
    certificates: (
      (name: "", issuer: "Nobody"),
      (issuer: "Other Nobody"), // `name` missing entirely → defaults to ""
    ),
  ),
  preferences: (
    groupCertificates: false,
  ),
)
