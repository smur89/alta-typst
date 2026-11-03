// Page footer — resolves `pageFooter` / `lastModifiedFooter` into the
// value for `set page(...)`. The "auto" footer hides itself on
// single-page documents via the reactive page counter, so it returns
// on its own when content grows.

#import "state.typ": _body_size_state
#import "theme.typ": _theme
#import "text.typ": _field, _fill_template, _string_at

// Both footers' text: small, in the body colour.
#let _footer_text(body) = context text(
  _theme.size.meta * _body_size_state.get(),
  fill: _theme.colour.body,
  body,
)

#let _auto_page_footer(name, page-number) = context {
  let total = counter(page).final().first()
  if total <= 1 { return }
  _footer_text(grid(
    columns: (1fr, auto),
    align: (left, right),
    name,
    _fill_template(page-number, (
      current: str(counter(page).get().first()),
      total: str(total),
    )),
  ))
}

// `pageFooter` takes precedence; `lastModifiedFooter` is sugar that
// applies only when `pageFooter` is `none`.
#let _resolve_page_footer(preferences, labels, meta, name) = {
  let page-footer = preferences.pageFooter
  let last-modified = _field(meta, "lastModified")
  if page-footer != none {
    if page-footer == "auto" {
      _auto_page_footer(name, labels.pageNumber)
    } else {
      page-footer
    }
  } else if preferences.lastModifiedFooter and last-modified != none {
    // `meta.version` is verbatim: the schema's own example already
    // carries the "v".
    let version = _string_at(meta, "version")
    let version-suffix = if preferences.footerVersion and version != none {
      " (" + version + ")"
    } else { "" }
    align(right, _footer_text({
      labels.lastModified
      ": "
      last-modified
      version-suffix
    }))
  } else {
    none
  }
}
