// A markup CV ending with `#pagebreak()`: the blank last page Typst
// adds keeps the template's labels and theme (`separator.label`) in
// its footers.

#import "/lib.typ": altacv, cv-footer, cv-updated-footer
#import "/tests/unit/_count.typ": count

#set document(author: "Jane Doe")
#show: altacv.with(
  theme: (separator: (label: " ~ ")),
  labels: (page-number: "Seite {current}", last-modified: "Stand"),
)
#set page(footer: {
  cv-footer()
  cv-updated-footer(date: "Mai 2026")
})

#let (seiten, seite-rule) = count("Seite")
#show "Seite": seite-rule
#let (stand, stand-rule) = count("Stand ~ Mai 2026")
#show "Stand ~ Mai 2026": stand-rule

= Erfahrung
#pagebreak()

#context {
  assert.eq(counter(page).final().first(), 2)
  assert.eq(seiten.final(), 2)
  assert.eq(stand.final(), 2)
}
