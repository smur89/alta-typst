// The footer helpers leave nothing for `query(metadata)` (or
// `typst query .. metadata`) to find: not on a page outside every
// template, nor on those of a CV in markup under nested templates.
// The name is counted per page, so the footers are drawn on each.

#import "/lib.typ": altacv, cv-footer, cv-updated-footer
#import "/tests/unit/_count.typ": count

#set document(author: "Jane Doe")
#set page(footer: {
  cv-footer()
  cv-updated-footer(date: "May 2026")
})

#let (names, name-rule) = count("Jane Doe")
#show "Jane Doe": name-rule

Outside every template.

#show: altacv
= Outer
#[
  #show: altacv.with(labels: (page-number: "Seite {current}"))
  = Inner
  #pagebreak()
  = Inner again
]
= Outer again

#context {
  let n = counter(page).final().first()
  assert.eq(n, 5)
  assert.eq(names.final(), n)
  assert.eq(query(metadata), ())
}
