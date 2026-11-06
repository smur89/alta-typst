// `altacv.with(labels: ..)` with `alta(cv)`: the template's labels
// reach the CV's headings and footers, and `alta(cv, labels: ..)`'s
// win over them for that CV, its entries' "Present" and date and
// location alt text and the header's location contact included.
// After it, a markup entry reads the template's again.

#import "/lib.typ": alta, altacv, cv-footer, entry
#import "/tests/unit/_count.typ": count

#show: altacv.with(labels: (
  present: "Jetzt",
  date: "Datum",
  location: "Ort",
  work: "Arbeit",
  page-number: "Seite {current}",
))
#set page(footer: cv-footer())

#let (nows, now-rule) = count("Now")
#show "Now": now-rule
#let (jetzts, jetzt-rule) = count("Jetzt")
#show "Jetzt": jetzt-rule
#let (pages, page-rule) = count("Seite")
#show "Seite": page-rule
#let alts = state("alts", ())
#show figure: it => {
  alts.update(xs => xs + (it.alt,))
  it
}
#let sections = state("sections", ())
#show heading.where(level: 1): it => {
  sections.update(xs => xs + (it.body,))
  it
}

#alta(
  (
    basics: (name: "Jane Doe", location: (city: "Cork")),
    work: (
      (
        name: "Acme",
        position: "Engineer",
        startDate: "2020-01",
        location: "Cork",
      ),
    ),
  ),
  labels: (present: "Now", date: "When", location: "Where"),
)
#pagebreak()
= Mehr
#entry(title: "Talk", date: ("2024", none), location: "Berlin")

#context {
  assert.eq(nows.final(), 1)
  assert.eq(jetzts.final(), 1)
  assert.eq(pages.final(), 2)
  assert.eq(sections.final(), ([Arbeit], [Mehr]))
  assert.eq(alts.final(), ("Where", "When", "Where", "Datum", "Ort"))
}
