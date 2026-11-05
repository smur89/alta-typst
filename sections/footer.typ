// The page footer: `preferences.page-footer` / `last-modified-footer`,
// `labels` and the CV's `meta` mapped onto the footers in
// `internal/components/footer.typ`, as the value for `set page(...)`.
// `alta-footer` and `alta-updated-footer` are the same footers for the
// altacv template, where the footer is the user's own set rule: they
// read the CV from the marker `alta()` emits.

#import "../internal/util/fields.typ": _field, _string-at
#import "../internal/components/footer.typ": _auto-page-footer, _updated-footer
#import "../internal/design/styles.typ": _part

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

// The `alta()` marker's details, for a footer helper; `none` before a
// CV is placed.
#let _cv-details() = query(<alta-cv>).at(0, default: none)

/// A page footer for `set page(footer: ..)` inside the altacv template:
/// your name on the left, the page number (`labels.page-number`) on the
/// right, on CVs of more than one page.
/// -> content
#let alta-footer() = context {
  let cv = _cv-details()
  if cv != none {
    _part("footer", _auto-page-footer(cv.value.owner, cv.value.page-number))
  }
}

/// A page footer for `set page(footer: ..)` inside the altacv template:
/// `labels.last-modified: meta.lastModified`, right-aligned.
///
/// - version (bool): Append `(meta.version)`.
/// -> content
#let alta-updated-footer(version: false) = context {
  let cv = _cv-details()
  if cv != none and cv.value.last-modified != none {
    let (last-modified, last-modified-label, version: v, ..) = cv.value
    _part("footer", _updated-footer(last-modified-label, {
      last-modified
      if version and v != none { " (" + v + ")" }
    }))
  }
}
