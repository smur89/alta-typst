// The page footer: `preferences.page-footer` / `last-modified-footer`,
// `labels` and the CV's `meta` mapped onto the footers in
// `internal/components/footer.typ`, as the value for `set page(...)`.

#import "../internal/util/fields.typ": _field, _string-at
#import "../internal/components/footer.typ": _auto-page-footer, _updated-footer

// `page-footer` takes precedence; `last-modified-footer` is sugar that
// applies only when `page-footer` is `none`.
#let _footer(cv, (labels, prefs, owner, ..)) = {
  let meta = cv.meta
  let page-footer = prefs.page-footer
  let last-modified = _field(meta, "last-modified")
  if page-footer != none {
    if page-footer == auto {
      _auto-page-footer(owner, labels.page-number)
    } else {
      page-footer
    }
  } else if prefs.last-modified-footer and last-modified != none {
    // `meta.version` is verbatim: the schema's own example already
    // carries the "v".
    let version = _string-at(meta, "version")
    let version-suffix = if prefs.footer-version and version != none {
      " (" + version + ")"
    } else { "" }
    _updated-footer(labels.last-modified, {
      last-modified
      version-suffix
    })
  } else {
    none
  }
}
