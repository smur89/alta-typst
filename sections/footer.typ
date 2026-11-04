// The page footer: `preferences.pageFooter` / `lastModifiedFooter`,
// `labels` and the CV's `meta` mapped onto the footers in
// `internal/components/footer.typ`, as the value for `set page(...)`.

#import "../internal/util/fields.typ": _field, _string-at
#import "../internal/components/footer.typ": _auto-page-footer, _updated-footer

// `pageFooter` takes precedence; `lastModifiedFooter` is sugar that
// applies only when `pageFooter` is `none`.
#let _footer(cv, (labels, prefs, owner, ..)) = {
  let meta = cv.meta
  let page-footer = prefs.pageFooter
  let last-modified = _field(meta, "lastModified")
  if page-footer != none {
    if page-footer == auto {
      _auto-page-footer(owner, labels.pageNumber)
    } else {
      page-footer
    }
  } else if prefs.lastModifiedFooter and last-modified != none {
    // `meta.version` is verbatim: the schema's own example already
    // carries the "v".
    let version = _string-at(meta, "version")
    let version-suffix = if prefs.footerVersion and version != none {
      " (" + version + ")"
    } else { "" }
    _updated-footer(labels.lastModified, {
      last-modified
      version-suffix
    })
  } else {
    none
  }
}
