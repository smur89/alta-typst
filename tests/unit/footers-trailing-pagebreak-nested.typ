// Nested templates ending with `#pagebreak()`: the nested template's
// labels and theme (`separator.label`) on its pages only (Typst adds
// no blank page after it, as the outer template's margins start one
// anyway); the outer template's on its own pages, the blank last page
// too.

#import "/lib.typ": altacv, cv-footer, cv-updated-footer
#import "/tests/unit/_count.typ": count

#set document(author: "Jane Doe")
#show: altacv.with(labels: (page-number: "Sheet {current}"))
#set page(footer: {
  cv-footer()
  cv-updated-footer(date: "May 2026")
})

#let (sheets, sheet-rule) = count("Sheet")
#show "Sheet": sheet-rule
#let (seiten, seite-rule) = count("Seite")
#show "Seite": seite-rule
#let (stand, stand-rule) = count("Stand ~ May 2026")
#show "Stand ~ May 2026": stand-rule
#let (updated, updated-rule) = count("Last updated: May 2026")
#show "Last updated: May 2026": updated-rule

= Experience
#[
  #show: altacv.with(
    theme: (separator: (label: " ~ ")),
    labels: (page-number: "Seite {current}", last-modified: "Stand"),
  )
  = Erfahrung
  #pagebreak()
]
= Education
#pagebreak()

#context {
  assert.eq(counter(page).final().first(), 4)
  // Page 2, the nested template's, then 1, 3 and 4.
  assert.eq(seiten.final(), 1)
  assert.eq(stand.final(), 1)
  assert.eq(sheets.final(), 3)
  assert.eq(updated.final(), 3)
}
