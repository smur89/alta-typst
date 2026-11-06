// Pins the contract that an unmodified resume.json on the current
// JSON Resume schema (no altacv extensions, free-text fluency) parses
// and renders without edits. Checking the schema is gairm-import's job.

#import "../internal/data/json-resume.typ": from-json-resume
#import "../lib.typ": alta

#let resume = from-json-resume(path("fixtures/canonical_resume.json"))

// Extension fields explicitly absent (not just empty) — pins
// "vanilla resume.json works without edits".
#assert("focusAreas" not in resume)
#assert("rating" not in resume.languages.at(1))

// altacv's deprecated top-level extensions (`focusAreas`,
// `languages[].rating`) and a free-text publication `type` come through
// as given, so drift between gairm-import's coerced output and what
// altacv's sections consume fails here. tests/custom-altacv.typ renders
// the deprecated extensions, tests/publication-types.typ free-text types.
#let legacy = from-json-resume((
  basics: (
    name: "Jane Doe",
    label: "Senior Software Engineer",
    email: "jane@example.com",
    summary: "Backend engineer with eight years of experience.",
  ),
  work: (
    (
      name: "Acme Corp",
      position: "Senior Software Engineer",
      startDate: "2022-01",
      highlights: ("Led the migration.", "Designed the platform."),
    ),
  ),
  focusAreas: ("Distributed systems", "Functional programming"),
  languages: (
    (language: "English", fluency: "Native"),
    (language: "Irish", rating: 4),
  ),
  publications: (
    (name: "A Paper", type: "Articles", releaseDate: "2024"),
  ),
))

#assert.eq(legacy.basics.name, "Jane Doe")
#assert.eq(legacy.focusAreas.len(), 2)
#assert.eq(legacy.languages.at(1).rating, 4)
#assert.eq(legacy.publications.at(0).type, "Articles")
#assert.eq(legacy.publications.at(0).releaseDate, "2024")
#assert.eq(legacy.work.at(0).startDate, "2022-01")

#alta(resume)
