// The page footer: `preferences.pageFooter` / `lastModifiedFooter`,
// `labels` and the CV's `meta` mapped onto the footers in
// `internal/components/footer.typ`, as the value for `set page(...)`.

#import "../internal/util/fields.typ": _field, _string_at
#import "../internal/components/footer.typ": _auto_page_footer, _updated_footer

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
    _updated_footer({
      labels.lastModified
      ": "
      last-modified
      version-suffix
    })
  } else {
    none
  }
}
