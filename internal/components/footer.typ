// The page footers `sections/footer.typ` chooses between: the page
// counter, which hides itself on single-page documents via the
// reactive page counter (so it returns on its own when content grows),
// and the right-aligned "last updated" line.

#import "../design/theme.typ": _theme
#import "../context.typ": _body_size_state
#import "../util/values.typ": _fill_template

// Both footers' text: small, in the body colour. Called in `context`,
// which supplies `body-size`.
#let _footer_text(body-size, body) = text(
  _theme.size.meta * body-size,
  fill: _theme.colour.body,
  body,
)

#let _auto_page_footer(name, page-number) = context {
  let total = counter(page).final().first()
  if total <= 1 { return }
  _footer_text(_body_size_state.get(), grid(
    columns: (1fr, auto),
    align: (left, right),
    name,
    _fill_template(page-number, (
      current: str(counter(page).get().first()),
      total: str(total),
    )),
  ))
}

#let _updated_footer(body) = context align(
  right,
  _footer_text(_body_size_state.get(), body),
)
