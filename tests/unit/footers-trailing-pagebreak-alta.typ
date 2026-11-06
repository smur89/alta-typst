// Two `alta()` CVs in a template ending with `#pagebreak()`: each CV's
// labels on its pages, and the last CV's on the blank page the
// trailing break adds, inside the template's scope.

#import "/lib.typ": alta, altacv, cv-footer
#import "/tests/unit/_count.typ": count

#show: altacv
#set page(footer: cv-footer())

#let (sheets, sheet-rule) = count("Sheet")
#show "Sheet": sheet-rule
#let (blaetter, blatt-rule) = count("Blatt")
#show "Blatt": blatt-rule
#let (names, name-rule) = count("Joan Roe")
#show "Joan Roe": name-rule

#alta(
  (basics: (name: "Jane Doe")),
  labels: (page-number: "Sheet {current}"),
)
#pagebreak()
#alta(
  (basics: (name: "Joan Roe")),
  labels: (page-number: "Blatt {current}"),
)
#pagebreak()

#context {
  assert.eq(counter(page).final().first(), 3)
  assert.eq(sheets.final(), 1)
  assert.eq(blaetter.final(), 2)
  // The second CV's name in its header and the last two footers.
  assert.eq(names.final(), 3)
}
