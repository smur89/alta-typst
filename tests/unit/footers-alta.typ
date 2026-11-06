// The footer helpers after `alta(cv)`: the CV's name and
// `meta.lastModified` over the document's author, with `labels` as
// `alta()` merged them; a `date:` replaces the CV's.

#import "/lib.typ": alta, alta-footer, alta-updated-footer, altacv

#set document(title: "Doc Title", author: "Doc Author")
#show: altacv
#set page(
  header: {
    alta-updated-footer(version: true)
    alta-updated-footer(date: "Nov 2026")
  },
  footer: alta-footer(),
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
#let (authors, author-rule) = count("Doc Author")
#show "Doc Author": author-rule
#let (pages, page-rule) = count("Sheet")
#show "Sheet": page-rule
#let (cv-dates, cv-date-rule) = count("Edited: 2025-06 (v2)")
#show "Edited: 2025-06 (v2)": cv-date-rule
#let (dates, date-rule) = count("Edited: Nov 2026")
#show "Edited: Nov 2026": date-rule

#alta(
  (
    basics: (name: "Jane Doe"),
    meta: (lastModified: "2025-06", version: "v2"),
  ),
  labels: (page-number: "Sheet {current} of {total}", last-modified: "Edited"),
)
#pagebreak()
= More

#context {
  assert.eq(authors.final(), 0)
  assert.eq(pages.final(), 2)
  assert.eq(cv-dates.final(), 2)
  assert.eq(dates.final(), 2)
}
