// Certificates with optional `date` and `url`. The name links to
// `url` when present, and the calendar-icon term row appears when
// `date` is supplied. Covers: full entry, url-only, date-only,
// name-only, and several certs from one issuer (mixed metadata). The
// deprecated `groupCertificates: false` is checked by
// group-certificates-deprecated.

#import "/lib.typ": alta
#import "/tests/fixtures/certificates.typ": cv

#alta(cv)

#pagebreak()

// Empty-string `date` / `url` are treated as absent — no orphan
// calendar icon, no link to "". `none` is handled the same way.
// The trailing dateless entry in a dated group must not emit a
// stray linebreak before the divider.
#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  certificates: (
    (
      name: "Empty strings are absent",
      issuer: "Acme",
      date: "",
      url: "",
    ),
    (
      name: "Explicit none is absent",
      issuer: "Acme",
      date: none,
      url: none,
    ),
    (
      name: "Dated cert (first)",
      issuer: "Globex",
      date: "Jan 2024",
    ),
    (
      name: "Trailing dateless cert (last in group)",
      issuer: "Globex",
    ),
  ),
))
