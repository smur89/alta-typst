// All certificates have empty / missing `name`. The Certifications
// section should be suppressed entirely — no orphan heading with no
// items below it. Exercises the `groupCertificates: false` path,
// which is where the regression lived; the `true` path was already
// correct via `_build_cert_groups`.

#import "../lib.typ": alta

#alta(
  (
    basics: (name: "All Names Empty", email: "x@example.com"),
    certificates: (
      (name: "", issuer: "Nobody"),
      (issuer: "Other Nobody"),  // `name` missing entirely → defaults to ""
    ),
  ),
  preferences: (
    groupCertificates: false,
  ),
)
