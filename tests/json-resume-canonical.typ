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

#alta(resume)
