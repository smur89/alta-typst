// `cv-footer()` in a markup CV whose document has a title but no
// author: the title stands in for the name.

#import "/lib.typ": altacv, cv-footer

#set document(title: "Jane Doe")
#show: altacv
#set page(footer: cv-footer())

#let names = state("names", 0)
#show "Jane Doe": it => {
  names.update(n => n + 1)
  it
}
#let pages = state("pages", 0)
#show "Page": it => {
  pages.update(n => n + 1)
  it
}

= Experience
#pagebreak()
= Education

#context assert.eq((names.final(), pages.final()), (2, 2))
