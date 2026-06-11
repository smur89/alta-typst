// Preference overrides: custom accent + ungrouped certificates +
// localised labels. Exercises _strict_merge for both `labels` and
// `preferences`.

#import "../lib.typ": alta

#alta(
  (
    basics: (name: "Jane Doe", email: "jane@example.com"),
    work: (
      (
        name: "Acme",
        position: "Engineer",
        startDate: "Jan 2022",
        highlights: ([Did work.],),
      ),
    ),
    certificates: (
      (name: "AWS SA Pro",  issuer: "Amazon Web Services"),
      (name: "AWS DevOps",  issuer: "Amazon Web Services"),
      (name: "CKA",         issuer: "CNCF"),
    ),
  ),
  preferences: (
    accent: rgb("#1976D2"),
    groupCertificates: false,
  ),
  labels: (
    experience: "Berufserfahrung",
    certifications: "Zertifikate",
    present: "Heute",
  ),
)
