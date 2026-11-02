// JSON Resume 1.4.0's certificate fields. Covers:
//   - `date` + `expiryDate` → a range inside the pill
//   - `date` alone → the single date, never "Present" (a certificate
//     without an expiry doesn't expire)
//   - `summary` as a string and as content → a plain paragraph under
//     the pill, which takes its own line
//   - `credentialId` on a cert in an issuer group and on one with no
//     issuer (and no date) → "ID <value>" in the pill, from
//     `labels.credentialId`
//   - an entry with none of the new fields, which renders as before
//   - empty-string new fields, which are treated as absent
// A second render runs the same data flat (`groupCertificates: false`)
// with the `short` `dateFormat`, so the range follows the preference,
// and an overridden `labels.credentialId`.

#import "../lib.typ": alta

#let cv = (
  basics: (name: "Jane Doe", email: "jane@example.com"),
  certificates: (
    // Every new field at once, in a grouped (CNCF) cluster.
    (
      name: "Certified Kubernetes Administrator",
      issuer: "CNCF",
      date: "2024-03",
      expiryDate: "2027-03",
      credentialId: "LF-ABC123",
      url: "https://example.com/cka",
      summary: "Cluster installation, networking, storage and troubleshooting.",
    ),
    // No expiry: the single date stays, with no "Present".
    (
      name: "Certified Kubernetes Application Developer",
      issuer: "CNCF",
      date: "2023-06",
    ),
    // Content summary, no other new field.
    (
      name: "AWS Solutions Architect — Associate",
      issuer: "AWS",
      date: "2022-05",
      summary: [Designing *resilient*, cost-aware AWS architectures.],
    ),
    // credentialId with no issuer and no date.
    (
      name: "Scrum Master",
      credentialId: "PSM-0042",
    ),
    // None of the new fields: renders exactly as before.
    (
      name: "Terraform Associate",
      issuer: "HashiCorp",
      date: "2021-11",
    ),
    // Empty strings are absent: no dash, no "ID", no paragraph.
    (
      name: "Empty new fields",
      issuer: "Acme",
      date: "2020-01",
      expiryDate: "",
      credentialId: "",
      summary: "",
    ),
  ),
)

#alta(cv)

#pagebreak()

#alta(
  cv,
  preferences: (groupCertificates: false, dateFormat: "short"),
  labels: (credentialId: "Credential"),
)
