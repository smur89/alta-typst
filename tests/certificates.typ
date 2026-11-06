// JSON Resume `certificates`. Documents:
//
//   1. `issuer` renders in bold accent on each certificate's term row;
//      a missing, empty or `none` issuer leaves it out.
//   2. Optional `date` and `url`: the name links to `url` when present,
//      and the calendar-icon term row appears when `date` is supplied.
//      Covers a full entry, url-only, date-only, name-only, and several
//      certs from one issuer (mixed metadata).
//   3. The same with the deprecated `group-certificates: false`, which
//      has no effect.
//   4. Empty-string and `none` `date` / `url` are absent.
//   5. JSON Resume 1.4.0's fields:
//        - `date` + `expiryDate` → a range on the term row
//        - `date` alone → the single date, never "Present" (a
//          certificate without an expiry doesn't expire)
//        - `summary` as a string and as content → a plain paragraph
//        - `credentialId` with an issuer and on one with no issuer
//          (and no date) → the bare ID on the term row
//        - an entry with none of the new fields
//        - empty-string new fields, which are treated as absent
//   6. The same with the `short` `date-format`, so the range follows
//      the preference, and `group-certificates: false`.
//   7. Every certificate with an empty or missing `name`: the section
//      is suppressed entirely, no orphan heading with no items below
//      it. Also sets `group-certificates: false`, which is where an
//      earlier regression lived.

#import "../lib.typ": alta

#alta((
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
))

#pagebreak()

#let metadata-cv = (
  basics: (name: "Jane Doe", email: "jane@example.com"),
  certificates: (
    // Full entry — tag is linked, date row follows.
    (
      name: "Certified Kubernetes Administrator",
      issuer: "CNCF",
      date: "Aug 2023",
      url: "https://example.com/cka",
    ),
    // Same issuer as the entry above. Mixes a dated + linked cert
    // with one that has neither, exercising each optional part.
    (
      name: "Certified Kubernetes Application Developer",
      issuer: "CNCF",
    ),
    // Url-only — link wraps the tag, no date line.
    (
      name: "AWS Solutions Architect — Associate",
      issuer: "AWS",
      url: "https://example.com/aws-saa",
    ),
    // Date-only — plain tag plus the calendar-icon date line.
    (
      name: "Terraform Associate",
      issuer: "HashiCorp",
      date: "May 2022",
    ),
  ),
)

#alta(metadata-cv)

#pagebreak()

// Same data with `group-certificates: false` to exercise the flat path.
#alta(metadata-cv, preferences: (group-certificates: false))

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

#pagebreak()

#let credential-cv = (
  basics: (name: "Jane Doe", email: "jane@example.com"),
  certificates: (
    // Every new field at once.
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
    // None of the new fields: name, date and issuer only.
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

#alta(credential-cv)

#pagebreak()

#alta(
  credential-cv,
  preferences: (group-certificates: false, date-format: "short"),
)

#pagebreak()

#alta(
  (
    basics: (name: "All Names Empty", email: "x@example.com"),
    certificates: (
      (name: "", issuer: "Nobody"),
      (issuer: "Other Nobody"), // `name` missing entirely → defaults to ""
    ),
  ),
  preferences: (
    group-certificates: false,
  ),
)
