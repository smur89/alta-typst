// JSON Resume `meta` block feeds PDF metadata (date / keywords /
// description) and, when `preferences.lastModifiedFooter` is set,
// also renders a visible "Last updated: …" footer.
//
// `basics.summary` flows into the PDF description; `skills[].keywords`
// flatten and de-duplicate into the PDF keywords field; the calendar
// part of `meta.lastModified` becomes the PDF date. `meta.canonical`
// and `meta.version` append to the PDF keywords (no dedicated Typst
// document field for either), and with `preferences.footerVersion` the
// version also suffixes the footer line — "Last updated: … (v1.0.0)".

#import "../lib.typ": alta

#alta(
  (
    basics: (
      name: "Jane Doe",
      email: "jane@example.com",
      summary: [Backend engineer with eight years' experience.],
    ),
    skills: (
      // "Scala" appears in two groups — de-duplication keeps a single
      // entry in the PDF Keywords field.
      (name: "Languages", keywords: ("Scala", "Python")),
      (name: "Infra", keywords: ("Kafka", "AWS", "Scala")),
    ),
    work: (
      (
        name: "Acme Corp",
        position: "Senior Software Engineer",
        startDate: "Jan 2022",
        highlights: ([Led a migration.],),
      ),
    ),
    // Full ISO 8601 timestamp — only the YYYY-MM-DD prefix is used
    // for the PDF date; the visible footer renders the string as-is.
    meta: (
      canonical: "https://example.com/cv.json",
      version: "v1.0.0",
      lastModified: "2026-06-12T14:00:00Z",
    ),
  ),
  preferences: (
    lastModifiedFooter: true,
    footerVersion: true,
  ),
)
