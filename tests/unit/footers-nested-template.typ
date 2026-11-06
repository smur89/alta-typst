// The footer helpers after `alta(cv)`, under a nested template with
// labels of its own: on every page of the nested template, its last
// too, its labels replace the CV's, the name still the CV's. On
// the pages after it, the CV's labels hold again.

#import "/lib.typ": alta, altacv, cv-footer
#import "/tests/unit/_count.typ": count

#show: altacv
#set page(footer: cv-footer())

#let (seiten, seite-rule) = count("Seite")
#show "Seite": seite-rule
#let (sheets, sheet-rule) = count("Sheet")
#show "Sheet": sheet-rule
#let (names, name-rule) = count("Jane Doe")
#show "Jane Doe": name-rule

#alta(
  (basics: (name: "Jane Doe")),
  labels: (page-number: "Sheet {current}"),
)
// Its own pages: the nested template's margins start a page, as the
// outer one's do again after it.
#[
  #show: altacv.with(labels: (page-number: "Seite {current}"))
  = Mehr
  #pagebreak()
  = Noch mehr
]
= More

#context {
  let n = counter(page).final().first()
  assert.eq(n, 4)
  // Pages 2 and 3, the nested scope's, its last too.
  assert.eq(seiten.final(), 2)
  assert.eq(sheets.final(), 2)
  // The CV's name in every footer, and once in its header.
  assert.eq(names.final(), n + 1)
}
