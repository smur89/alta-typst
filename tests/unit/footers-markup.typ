// The footer helpers in a CV written in markup, with no `alta()` to
// read: the name from `document.author`, the labels in the document's
// language, and `cv-updated-footer` printing only with a `date:`.
// Each string is counted per page through a show rule.

#import "/lib.typ": altacv, cv-footer, cv-updated-footer

#set document(title: "Doc Title", author: "Jane Doe")
#show: altacv
#set text(lang: "ga")
#set page(
  header: {
    cv-updated-footer()
    cv-updated-footer(date: "Samhain 2026", version: true)
  },
  footer: cv-footer(),
)

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
#let (names, name-rule) = count("Jane Doe")
#show "Jane Doe": name-rule
#let (titles, title-rule) = count("Doc Title")
#show "Doc Title": title-rule
#let (pages, page-rule) = count("Leathanach")
#show "Leathanach": page-rule
#let (updated, updated-rule) = count("Nuashonraithe")
#show "Nuashonraithe": updated-rule
#let (dates, date-rule) = count("Samhain 2026")
#show "Samhain 2026": date-rule

= Taithí
#pagebreak()
= Oideachas

#context {
  assert.eq(names.final(), 2)
  assert.eq(titles.final(), 0)
  assert.eq(pages.final(), 2)
  assert.eq(updated.final(), 2)
  assert.eq(dates.final(), 2)
}
