// Pins the contract that an unmodified resume.json (no altacv
// extensions, free-text fluency) parses + renders without edits.

#import "../lib.typ": alta, from-json-resume

#let resume = from-json-resume(path("fixtures/canonical_resume.json"))

// Negative-space pin — a new top-level key in the dict fails here
// instead of slipping past the positive asserts below.
#assert.eq(
  resume.keys().sorted(),
  (
    "basics",
    "education",
    "languages",
    "projects",
    "publications",
    "skills",
    "work",
  ),
)

#assert.eq(resume.basics.name, "Jane Doe")
#assert.eq(resume.basics.location.city, "Dublin")
#assert.eq(resume.basics.profiles.len(), 1)
#assert.eq(resume.work.len(), 1)
#assert.eq(resume.work.at(0).startDate, "2022-01")
#assert.eq(resume.education.len(), 1)
#assert.eq(resume.skills.len(), 1)
#assert.eq(resume.languages.len(), 2)
#assert.eq(resume.publications.len(), 1)
#assert.eq(resume.publications.at(0).releaseDate, "2024-09")
#assert.eq(resume.projects.len(), 1)

// Extension fields explicitly absent (not just empty) — pins
// "vanilla resume.json works without edits".
#assert("focusAreas" not in resume)
#assert("rating" not in resume.languages.at(1))
#assert("type" not in resume.publications.at(0))

#alta(resume)
