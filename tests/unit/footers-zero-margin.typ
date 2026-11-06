// A template ending with `#pagebreak()` on pages with no top or left
// margin: the blank last page keeps the template's labels.

#import "/lib.typ": altacv, cv-footer
#import "/tests/unit/_count.typ": count

#set document(author: "Jane Doe")
#show: altacv.with(labels: (page-number: "Seite {current}"))
#set page(footer: cv-footer(), margin: (x: 0pt, top: 0pt, bottom: 2cm))

#let (seiten, seite-rule) = count("Seite")
#show "Seite": seite-rule

= Erfahrung
#pagebreak()

#context {
  assert.eq(counter(page).final().first(), 2)
  assert.eq(seiten.final(), 2)
}
