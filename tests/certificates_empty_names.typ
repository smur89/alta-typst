// Certificates whose `name` fields are all empty (or missing) should
// render no Certifications section at all — not an orphan heading
// with no items underneath. Exercises both code paths:
//
//   - `groupCertificates: true`  (default) — _build_cert_groups already
//                                            dropped empty names, so the
//                                            heading was correctly skipped.
//   - `groupCertificates: false` — the ungrouped branch used to wrap an
//                                  empty filtered names array into a
//                                  single-element tuple `((),)`, emitting
//                                  the heading anyway. Now also skipped.

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
