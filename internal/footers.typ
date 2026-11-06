// The template's page footers, `cv-footer` and `cv-updated-footer`,
// for the user's own `set page(footer: ..)`: what they print of the CV
// (`_cv-details`), read from the `<alta-cv>` marker `alta()` leaves,
// else from the document. Standalone `alta()` maps the same details
// onto its footer in `sections/footer.typ`.

#import "util/fields.typ": _field, _string-at
#import "util/checks.typ": _check-type
#import "components/footer.typ": (
  _auto-page-footer, _updated-footer, _updated-line,
)
#import "design/styles.typ": _part
#import "data/defaults.typ": _labels

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

// The marker of the CV this footer's page shows: the nearest before
// it, else the first, so a footer set before the CV still finds it;
// `none` with no CV placed.
#let _placed-cv() = {
  let before = query(selector(<alta-cv>).before(here()))
  if before != () { before.last() } else {
    query(<alta-cv>).at(0, default: none)
  }
}

// What the template's footers print: the placed CV's `_cv-details`,
// else, in a CV written in markup, the document's: its author (or
// title) for the name and the labels in its language, with no date.
#let _footer-details() = {
  let cv = _placed-cv()
  if cv != none { return cv.value }
  let labels = _labels()
  (
    owner: if document.author != () { document.author.join(", ") } else {
      document.title
    },
    last-modified: none,
    version: none,
    page-number: labels.page-number,
    last-modified-label: labels.last-modified,
  )
}

/// A page footer for `set page(footer: ..)` inside the altacv template:
/// your name on the left, the page number (`labels.page-number`) on the
/// right, on documents of more than one page. The name is `alta()`'s
/// `basics.name`; in a CV written in markup, the document's author
/// (`set document(author: ..)`), else its title. It counts pages with
/// Typst's page counter, so a `counter(page).update(..)` that restarts
/// it changes what counts as one page.
/// -> content
#let cv-footer() = context {
  let details = _footer-details()
  _part("footer", _auto-page-footer(details.owner, details.page-number))
}

/// A page footer for `set page(footer: ..)` inside the altacv template:
/// `labels.last-modified: meta.lastModified`, right-aligned. Nothing
/// when there's no date: in a CV written in markup, pass `date`.
///
/// - version (bool): Append `(meta.version)`.
/// - date (str, content, none): The date shown, as written, in place
///   of `alta()`'s `meta.lastModified`.
/// -> content
#let cv-updated-footer(version: false, date: none) = {
  _check-type(
    "cv-updated-footer() date",
    date,
    (str, content, type(none)),
    "a string or content",
  )
  context {
    let details = _footer-details()
    let details = if date != none { details + (last-modified: date) } else {
      details
    }
    if details.last-modified != none {
      _part("footer", _updated-footer(
        details.last-modified-label,
        _updated-line(details, version),
      ))
    }
  }
}
