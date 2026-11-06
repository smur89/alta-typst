// `altacv.with(labels: ..)` in a CV written in markup, in a language
// with no bundled translation: an entry's open-ended period reads the
// template's "Present", its date and location icons and the header's
// location contact read its alt text, and the footers its page and
// last-modified labels, camelCase accepted as `alta()` accepts it.
// After `set text(lang: "ga")`, the Irish translation sits under the
// template's labels.

#import "/lib.typ": (
  adapter, altacv, contact, cv-footer, cv-header, cv-updated-footer, entry,
)

#set document(title: "Jane Doe", author: "Jane Doe")
#show: altacv.with(labels: (
  present: "Jetzt",
  date: "Datum",
  location: "Ort",
  page-number: "Seite {current}",
  lastModified: "Stand",
))
#set text(lang: "de")
#set page(
  header: cv-updated-footer(date: "Mai 2026"),
  footer: cv-footer(),
)

#let count(s) = {
  let seen = state("seen-" + s, 0)
  (
    seen,
    it => {
      seen.update(n => n + 1)
      it
    },
  )
}
#let (nows, now-rule) = count("Jetzt")
#show "Jetzt": now-rule
#let (pages, page-rule) = count("Seite")
#show "Seite": page-rule
#let (updated, updated-rule) = count("Stand")
#show "Stand": updated-rule
// The alt text of each icon that has one.
#let alts = state("alts", ())
#show figure: it => {
  alts.update(xs => xs + (it.alt,))
  it
}

#cv-header(contacts: (contact("location", "Berlin"),))

= Erfahrung
#entry(title: "Engineer", date: ("2020", none), location: "Berlin")
#pagebreak()
= Ausbildung
#entry(title: "BSc", date: ("2016", "2019"))

#context assert.eq(adapter.labels().present, "Jetzt")

#set text(lang: "ga")
#context {
  let labels = adapter.labels()
  // The template's over the translation; the translation elsewhere.
  assert.eq(labels.present, "Jetzt")
  assert.eq(labels.work, "Taithí Oibre")
}

#context {
  assert.eq(nows.final(), 1)
  assert.eq(pages.final(), 2)
  assert.eq(updated.final(), 2)
  assert.eq(alts.final(), ("Ort", "Datum", "Ort", "Datum"))
}
