// from-json-resume: JSON Resume input with altacv's three extensions
// (focusAreas, languages[].rating, publications[].type) parses into
// the dict shape `alta` expects AND renders end-to-end. The two
// halves live in one fixture so a drift between gairm-import's
// strict-coerced output and what altacv's sections consume (content
// vs. str, required keys, etc.) fails the build instead of slipping
// through.
//
// Dates must be iso8601 (YYYY / YYYY-MM / YYYY-MM-DD) per the JSON
// Resume spec — presentation is altacv's `preferences.dateFormat`.

#import "../lib.typ": alta, from-json-resume

#let resume = from-json-resume((
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

#assert.eq(resume.basics.name, "Jane Doe")
#assert.eq(resume.focusAreas.len(), 2)
#assert.eq(resume.languages.at(1).rating, 4)
#assert.eq(resume.publications.at(0).type, "Articles")
#assert.eq(resume.publications.at(0).releaseDate, "2024")
#assert.eq(resume.work.at(0).startDate, "2022-01")

#alta(resume)
