// `basics.summary` rendered as a prose block between the header and
// the first section heading. Silently skipped when absent / empty.

#import "../internal/state.typ": _body_size_state

#let _summary(basics) = context {
  let summary = basics.at("summary", default: none)
  if summary == none or summary == [] { return }
  let body-size = _body_size_state.get()
  v(0.8 * body-size)
  par(summary)
  v(0.4 * body-size)
}
