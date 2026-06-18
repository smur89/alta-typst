// from-json-resume: a *canonical* JSON Resume — no altacv extensions
// (focusAreas / languages[].rating / publications[].type), `fluency`
// outside the LinkedIn enum — parses + renders seamlessly via
// `path(…)` input. The altacv overlay adds the extensions as optional,
// so a user dropping in an unmodified resume.json should not have to
// edit it. This fixture exercises both the parse path (asserts) and
// the render path so a regression in either fails the build.

#import "../lib.typ": alta, from-json-resume

#let resume = from-json-resume(path("fixtures/canonical_resume.json"))

// Negative-space: lock the canonical shape so a future schema
// addition that silently appears in the dict (e.g. a new top-level
// section the renderer doesn't yet handle) fails this assert instead
// of slipping past the positive checks below.
#assert.eq(
  resume.keys().sorted(),
  ("basics", "education", "languages", "projects", "publications", "skills", "work"),
)

// Canonical sections present in the expected shape.
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

// altacv extension fields explicitly absent — pins the "vanilla
// resume.json works without edits" contract. If the schema overlay
// ever made these required, these asserts would still hold (the parse
// step would have panicked earlier), so they double as documentation
// that the extension keys are genuinely optional.
#assert.eq(resume.at("focusAreas", default: ()), ())
#assert.eq(resume.languages.at(1).at("rating", default: none), none)
#assert.eq(resume.publications.at(0).at("type", default: none), none)

#alta(resume)
