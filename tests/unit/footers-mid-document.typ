// `set page(footer: ..)` part-way through, and again in a nested
// template that wraps the helper in its own content: each page draws
// the footer set where it starts, with the labels and theme
// (`separator.label`) of the template it sits in.

#import "/lib.typ": altacv, cv-footer, cv-updated-footer
#import "/tests/unit/_count.typ": count

#set document(author: "Jane Doe")
#show: altacv.with(
  theme: (separator: (label: " ~ ")),
  labels: (page-number: "Seite {current}", last-modified: "Stand"),
)
#set page(footer: cv-footer())

#let (seiten, seite-rule) = count("Seite")
#show "Seite": seite-rule
#let (stand, stand-rule) = count("Stand ~ Mai 2026")
#show "Stand ~ Mai 2026": stand-rule
#let (sheets, sheet-rule) = count("Sheet")
#show "Sheet": sheet-rule
#let (customs, custom-rule) = count("Custom")
#show "Custom": custom-rule

= Eins
#pagebreak()
#set page(footer: cv-updated-footer(date: "Mai 2026"))
= Zwei
#[
  #show: altacv.with(labels: (page-number: "Sheet {current}"))
  #set page(footer: [Custom #cv-footer()])
  = Three
  #pagebreak()
]
= Vier
#pagebreak()

#context {
  assert.eq(counter(page).final().first(), 5)
  // Page 1's, before the footer changes.
  assert.eq(seiten.final(), 1)
  // Pages 2, 4 and 5: the outer template's, its blank last page too.
  assert.eq(stand.final(), 3)
  // Page 3, the nested template's.
  assert.eq(customs.final(), 1)
  assert.eq(sheets.final(), 1)
}
