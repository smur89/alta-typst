// The JSON Resume mapping fed JSON Resume as a copy of it is, through
// gairm-import's `parse` (`resume(parse(path("resume.json")))`), with
// none of `alta()`'s canonicalisation: a project's `description`, JSON
// Resume's name for its summary, still shows, as do the older
// `description` of work and volunteer entries; a `summary` wins over it.

#import "/lib.typ": altacv
#import "@preview/gairm-import:0.10.1": parse
#import "/adapter/json-resume.typ": resume

#show: altacv

#let seen = state("seen", ())
#show <alta-summary>: it => {
  seen.update(xs => xs + (it,))
  it
}

#resume(parse(path("/tests/fixtures/canonical_resume.json")))
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

// JSON Resume requires no field, `basics` included: with none, the
// name is the document's title and there's no contact bar or QR code.
#[
  #set document(title: "Untitled CV")
  #let names = state("names", ())
  #show <alta-name>: it => {
    names.update(xs => xs + (it,))
    it
  }
  #resume((work: ((name: "Acme", position: "Engineer"),)))
  #context assert.eq(names.get(), ([Untitled CV],))
]

// A label the summary carries stays, beside the `<alta-summary>` part.
#[
  #let labels = state("labels", ())
  #show <mine>: it => {
    labels.update(xs => xs + ("mine",))
    it
  }
  #show <alta-summary>: it => {
    labels.update(xs => xs + ("part",))
    it
  }
  #resume((basics: (name: "Jane Doe", summary: [Intro.<mine>])))
  #context assert.eq(labels.get().sorted(), ("mine", "part"))
]
