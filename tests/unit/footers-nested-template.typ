// The footer helpers after `alta(cv)`, under a nested template with
// labels of its own: there, the labels in effect replace the CV's,
// the name still the CV's. Outside it, the CV's labels hold again.
// The nested scope's last page reads the enclosing labels, as its
// labels end with its body (the limitation `altacv` notes at its pop).

#import "/lib.typ": alta, altacv, cv-footer

#show: altacv
#set page(footer: cv-footer())

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
#[
  #show: altacv.with(labels: (page-number: "Seite {current}"))
  = Mehr
  #pagebreak()
  = Noch mehr
]
= More

#context {
  let n = counter(page).final().first()
  assert.eq(seiten.final(), 1)
  assert.eq(sheets.final(), n - 1)
  // The CV's name in every footer, and once in its header.
  assert.eq(names.final(), n + 1)
}
