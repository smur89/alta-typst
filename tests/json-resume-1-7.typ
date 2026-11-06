// Pins that a resume.json using JSON Resume 1.7.0's fields (and
// altacv's extensions under `custom.altacv`) parses and renders.

#import "../internal/data/json-resume.typ": from-json-resume
#import "../lib.typ": alta

#let resume = from-json-resume(path("fixtures/canonical_resume_1_7.json"))

// Negative-space pin — a new top-level key in the dict fails here
// instead of slipping past the positive asserts below.
#assert.eq(
  resume.keys().sorted(),
  (
    "awards",
    "basics",
    "certificates",
    "custom",
    "education",
    "languages",
    "objective",
    "publications",
    "references",
    "skills",
    "volunteer",
    "work",
  ),
)

#assert.eq(resume.basics.pronouns, "she/her")
#assert.eq(resume.work.at(0).keywords, ("Scala", "Kafka"))
#assert.eq(resume.work.at(0).location.city, "Cork")
#assert.eq(resume.volunteer.at(0).location, "Galway")
#assert.eq(resume.education.at(0).location.city, "Dublin")
#assert.eq(resume.certificates.at(0).credentialId, "LF-0000000000")
#assert.eq(resume.publications.at(0).type, "talk")
#assert.eq(resume.publications.at(0).identifiers.doi, "10.1000/182")
#assert.eq(resume.references.at(0).relationship, "Manager")
#assert.eq(resume.skills.at(0).custom.altacv.rating, 4.5)
#assert.eq(resume.languages.at(1).custom.altacv.rating, 3)
#assert.eq(resume.awards.at(0).custom.altacv.url, "https://example.com/paper")
#assert.eq(resume.custom.altacv.focusAreas.len(), 2)

#alta(resume)
