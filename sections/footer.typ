// The page footer: `preferences.page-footer` / `last-modified-footer`,
// `labels` and the CV's `meta` mapped onto the footers in
// `internal/components/footer.typ`, as the value for `set page(...)`.
// `alta-footer` and `alta-updated-footer` are the same footers for the
// altacv template, where the footer is the user's own set rule.

#import "../internal/util/fields.typ": _field, _string-at
#import "../internal/components/footer.typ": _auto-page-footer, _updated-footer
#import "../internal/design/styles.typ": _part

// What a footer prints of the CV: the standalone footer's input, and
// the `<alta-cv>` marker's value that the template's helpers read.
// `meta.version` is verbatim: the schema's own example already carries
// the "v".
#let _cv-details(cv, labels) = (
  owner: cv.basics.name,
  last-modified: _field(cv.meta, "last-modified"),
  version: _string-at(cv.meta, "version"),
  page-number: labels.page-number,
  last-modified-label: labels.last-modified,
)

// "last-modified (version)", the version only when asked for and set.
#let _updated-line((last-modified, version: v, ..), version) = {
  last-modified
  if version and v != none { " (" + v + ")" }
}

// From the CV's `_cv-details`. `page-footer` takes precedence;
// `last-modified-footer` is sugar that applies only when `page-footer`
// is `none`.
#let _footer(details, prefs) = {
  let page-footer = prefs.page-footer
  if page-footer != none {
    if page-footer == auto {
      _auto-page-footer(details.owner, details.page-number)
    } else {
      page-footer
    }
  } else if prefs.last-modified-footer and details.last-modified != none {
    _updated-footer(
      details.last-modified-label,
      _updated-line(details, prefs.footer-version),
    )
  } else {
    none
  }
}

// The marker of the CV this footer's page shows: the nearest before
// it, else the first, so a footer set before the CV still finds it;
// `none` with no CV placed.
#let _placed-cv() = {
  let before = query(selector(<alta-cv>).before(here()))
  if before != () { before.last() } else {
    query(<alta-cv>).at(0, default: none)
  }
}

/// A page footer for `set page(footer: ..)` inside the altacv template:
/// your name on the left, the page number (`labels.page-number`) on the
/// right, on documents of more than one page. It counts pages with
/// Typst's page counter, so a `counter(page).update(..)` that restarts
/// it changes what counts as one page.
/// -> content
#let alta-footer() = context {
  let cv = _placed-cv()
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
  let cv = _placed-cv()
  if cv != none and cv.value.last-modified != none {
    _part("footer", _updated-footer(
      cv.value.last-modified-label,
      _updated-line(cv.value, version),
    ))
  }
}
