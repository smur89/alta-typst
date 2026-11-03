// The page footers `sections/footer.typ` chooses between: the page
// counter, which hides itself on single-page documents via the
// reactive page counter (so it returns on its own when content grows),
// and the right-aligned "last updated" line, both in body text.

#import "../util/values.typ": _fill-template

#let _auto-page-footer(name, page-number) = context {
  let total = counter(page).final().first()
  if total <= 1 { return }
  grid(
    columns: (1fr, auto),
    align: (left, right),
    name,
    _fill-template(page-number, (
      current: str(counter(page).get().first()),
      total: str(total),
    )),
  )
}

#let _updated-footer(body) = align(right, body)
