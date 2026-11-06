// The JSON Resume mapping fed JSON Resume as a copy of it is, through
// gairm-import's `parse` (`resume(parse(path("resume.json")))`), with
// none of `alta()`'s canonicalisation: a project's `description`, JSON
// Resume's deprecated alias of its summary, still shows, a `summary`
// winning over it. A work entry's `description` is the company's, and
// doesn't stand in for its summary; `alta()` still reads the older
// exports' that way (#239), before the mapping sees the CV.

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
  work: (
    (name: "Acme", position: "Engineer", description: "Payments company."),
  ),
  projects: (
    (name: "P", description: "Old text.", summary: "A parser."),
    (name: "Q", description: "A lexer."),
  ),
))
#context assert.eq(seen.get(), ([A parser.], [A lexer.]))

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
