// The JSON Resume mapping fed raw JSON Resume, as a copy of it is
// (`resume(json("resume.json"))`), with none of `alta()`'s
// canonicalisation: a project's `description`, JSON Resume's name for
// its summary, still shows, as do the older `description` of work and
// volunteer entries; a `summary` wins over it.

#import "/lib.typ": altacv
#import "/adapter/json-resume.typ": resume

#show: altacv

#let seen = state("seen", ())
#show <alta-summary>: it => {
  seen.update(xs => xs + (it,))
  it
}

#resume(json("/tests/fixtures/canonical_resume.json"))
#context assert(
  [A small library for safe schema evolution.] in seen.get(),
  message: "the project's description is missing",
)

#seen.update(())
#resume((
  basics: (name: "Jane Doe"),
  work: ((name: "Acme", position: "Engineer", description: "Ran payments."),),
  volunteer: (
    (
      organization: "Dojo",
      position: "Mentor",
      description: "Old text.",
      summary: "Taught Python.",
    ),
  ),
))
#context assert.eq(seen.get(), ([Ran payments.], [Taught Python.]))
