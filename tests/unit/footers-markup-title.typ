// `cv-footer()` in a markup CV whose document has a title but no
// author: the title stands in for the name.

#import "/lib.typ": altacv, cv-footer
#import "/tests/unit/_count.typ": count

#set document(title: "Jane Doe")
#show: altacv
#set page(footer: cv-footer())

#let (names, name-rule) = count("Jane Doe")
#show "Jane Doe": name-rule
#let (pages, page-rule) = count("Page")
#show "Page": page-rule

= Experience
#pagebreak()
= Education

#context assert.eq((names.final(), pages.final()), (2, 2))
