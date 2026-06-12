// Certificates with optional `date` and `url`. Each cert pill wraps
// in a link when `url` is present, and a small calendar-icon date
// line follows the pill when `date` is supplied. Covers: full entry,
// url-only, date-only, name-only, grouped multi-cert issuer (mixed
// metadata), and the flat (groupCertificates: false) layout.

#import "../lib.typ": alta

#let cv = (
  basics: (name: "Jane Doe", email: "jane@example.com"),
  certificates: (
    // Full entry — pill is linked, date row follows.
    (
      name: "Certified Kubernetes Administrator",
      issuer: "CNCF",
      date: "Aug 2023",
      url: "https://example.com/cka",
    ),
    // Same issuer as the entry above → grouped together. Mixes a
    // dated + linked cert with one that has neither, exercising the
    // per-cert branching inside a group.
    (
      name: "Certified Kubernetes Application Developer",
      issuer: "CNCF",
    ),
    // Url-only — link wraps the pill, no date line.
    (
      name: "AWS Solutions Architect — Associate",
      issuer: "AWS",
      url: "https://example.com/aws-saa",
    ),
    // Date-only — plain pill plus the calendar-icon date line.
    (
      name: "Terraform Associate",
      issuer: "HashiCorp",
      date: "May 2022",
    ),
  ),
)

#alta(cv)

#pagebreak()

// Same data with `groupCertificates: false` to exercise the flat path.
#alta(cv, preferences: (groupCertificates: false))
