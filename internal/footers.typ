// The template's page footers, `cv-footer` and `cv-updated-footer`,
// for the user's own `set page(footer: ..)`: what they print of the CV
// (`_cv-details`), read from the `<alta-cv>` marker `alta()` leaves,
// else from the document. Standalone `alta()` maps the same details
// onto its footer in `sections/footer.typ`.
// Each helper returns a placeholder each `altacv` draws with a show
// rule holding its theme and labels: a footer takes its page's styles,
// those of the innermost template on it, where the state, read after
// the page's body, may already have left that template.

#import "util/fields.typ": _field, _string-at
#import "util/checks.typ": _check-type
#import "components/footer.typ": _auto-page-footer, _updated-footer
#import "design/styles.typ": _part
#import "context.typ": _labels, _theme

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
// The CV's labels (its call's over its templates') hold under the
// template `scope` it sits in; under others (a nested
// `altacv.with(labels: ..)` after it), the template's label `layers`
// replace them, the name and date still the CV's.
#let _footer-details(layers, scope) = {
  let label-details() = {
    let labels = _labels(layers: layers)
    (page-number: labels.page-number, last-modified-label: labels.last-modified)
  }
  let cv = _placed-cv()
  if cv != none {
    let (details, scope: cv-scope) = cv.value
    return if cv-scope == scope { details } else {
      details + label-details()
    }
  }
  (
    owner: if document.author != () { document.author.join(", ") } else {
      document.title
    },
    last-modified: none,
    version: none,
    ..label-details(),
  )
}

// A footer helper's placeholder: its `args` for the `_footer-rule` of
// each template around it, drawn: `draw`, a function of the details
// and the theme, and those templates' label `layers` and `scopes`,
// innermost first; outside every template, `draw` gets the theme where
// it's read. In a `pad` with no padding: a join would merge a bare
// sequence with the next helper's, and a block changes the PDF.
#let _footer-placeholder(args) = [#pad(
  metadata(args)
    + context (args.draw)(
      _footer-details(args.layers, args.scopes.at(0, default: none)),
      _theme(),
    ),
)<alta-internal-footer>]

// For each `altacv`'s `show <alta-internal-footer>: ..`: the placeholder
// again, with the template's `labels` layer under those of the
// templates inside it and its `scope` after theirs. The innermost
// template's rule applies first, and binds `draw` to its built
// `theme`; each applies once, as its scope then sits in `scopes`.
#let _footer-rule(theme, labels, scope) = it => {
  let args = it.body.children.first().value
  if scope in args.scopes { return it }
  let draw = if args.scopes == () {
    (details, _) => (args.draw)(details, theme)
  } else { args.draw }
  _footer-placeholder(
    args
      + (
        draw: draw,
        layers: (labels,) + args.layers,
        scopes: args.scopes + (scope,),
      ),
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
#let cv-footer() = _footer-placeholder((
  layers: (),
  scopes: (),
  draw: (details, _) => _part("footer", _auto-page-footer(
    details.owner,
    details.page-number,
  )),
))

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
  _footer-placeholder((
    layers: (),
    scopes: (),
    draw: (details, theme) => {
      let details = if date != none { details + (last-modified: date) } else {
        details
      }
      if details.last-modified != none {
        _part("footer", _updated-footer(
          details,
          version,
          theme.separator.label,
        ))
      }
    },
  ))
}
