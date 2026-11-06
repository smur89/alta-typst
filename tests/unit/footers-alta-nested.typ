// `alta()` CVs in an outer and a nested template: each CV's labels
// and the theme (`separator.label`) of the template it sits in on its
// own pages, the nested template's only on its pages, and after it the
// outer template's labels with the last CV's name.

#import "/lib.typ": alta, altacv, cv-footer, cv-updated-footer
#import "/tests/unit/_count.typ": count

#show: altacv.with(labels: (page-number: "Page {current}"))
#set page(footer: {
  cv-footer()
  cv-updated-footer(date: "May 2026")
})

#let (sheets, sheet-rule) = count("Sheet")
#show "Sheet": sheet-rule
#let (seiten, seite-rule) = count("Seite")
#show "Seite": seite-rule
#let (blaetter, blatt-rule) = count("Blatt")
#show "Blatt": blatt-rule
#let (pages, page-rule) = count("Page")
#show "Page": page-rule
#let (updated, updated-rule) = count("Last updated: May 2026")
#show "Last updated: May 2026": updated-rule
#let (stand, stand-rule) = count("Stand ~ May 2026")
#show "Stand ~ May 2026": stand-rule
#let (roes, roe-rule) = count("Joan Roe")
#show "Joan Roe": roe-rule

#alta(
  (basics: (name: "Jane Doe")),
  labels: (page-number: "Sheet {current}"),
)
#[
  #show: altacv.with(
    theme: (separator: (label: " ~ ")),
    labels: (page-number: "Seite {current}", last-modified: "Stand"),
  )
  = Innen
  #pagebreak()
  #alta(
    (basics: (name: "Joan Roe")),
    labels: (page-number: "Blatt {current}"),
  )
  #pagebreak()
]
= After
#pagebreak()
= Last

#context {
  assert.eq(counter(page).final().first(), 5)
  assert.eq(sheets.final(), 1)
  assert.eq(seiten.final(), 1)
  assert.eq(blaetter.final(), 1)
  assert.eq(pages.final(), 2)
  // Page 1, then 4 and 5: the outer template's separator.
  assert.eq(updated.final(), 3)
  assert.eq(stand.final(), 2)
  // In the second CV's header and the footers from its page on.
  assert.eq(roes.final(), 4)
}
