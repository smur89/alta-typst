// The page footers `sections/footer.typ` chooses between: the page
// counter, which hides itself on single-page documents via the
// reactive page counter (so it returns on its own when content grows),
// and the right-aligned "last updated" line (`Last updated: …`), both
// in body text.

#import "../context.typ": _theme
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

// `label` and `value` joined by the theme's `separator.label`.
#let _updated-footer(label, value) = align(right, context {
  label
  _theme().separator.label
  value
})
