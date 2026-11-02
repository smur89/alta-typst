// Publications — grouped by JSON Resume's `type` code (matched
// case-insensitively) with a type-appropriate icon on each subheading.
// Known codes take their subheading from `labels.publicationTypes`;
// other types print as first written. Untyped or invalid-type entries
// count as `article`. `authors` print under the title, the CV owner in
// bold. Persistent `identifiers` print under the date and give an
// unlinked title somewhere to point.

#import "../internal/state.typ": _body_colour, _body_size_state
#import "../internal/canonical.typ": _legacy_publication_icons
#import "../internal/text.typ": _present, _present_str, styled-link
#import "../internal/primitives.typ": _group_by
#import "../internal/icons.typ": icon
#import "../internal/dates.typ": _format_date

// Built-in icons, keyed by `type` (case-insensitive). Extend via
// `labels.publicationIcons`; unmatched types fall back to `file`.
// JSON Resume's codes (`patent` has no dedicated glyph, so it takes
// the `file` fallback):
#let _code_publication_icons = (
  article: "newspaper",
  book: "book",
  thesis: "book",
  talk: "microphone",
)
#let _default_publication_icons = (
  _code_publication_icons + _legacy_publication_icons
)

// A publication's group key: its lowercased `type`, or `article` when
// untyped or not a string, so `Talk` / `talk` and untyped / `article`
// each share one subheading.
#let _type_code(pub) = {
  let raw = pub.at("type", default: none)
  if _present_str(raw) { lower(raw) } else { "article" }
}

// JSON Resume 1.7.0 `publications[].identifiers`, keyed by scheme.
// Known schemes print under their conventional name (a proper noun, so
// not a label) and link to a URL prefix where one exists; others print
// as given. Linkable schemes are listed in the order an unlinked title
// prefers them.
#let _identifier_schemes = (
  doi: (name: "DOI", url: "https://doi.org/"),
  arxiv: (name: "arXiv", url: "https://arxiv.org/abs/"),
  pmid: (name: "PMID", url: "https://pubmed.ncbi.nlm.nih.gov/"),
  isbn: (name: "ISBN", url: none),
)
#let _identifier_scheme(scheme) = _identifier_schemes.at(
  scheme,
  default: (name: scheme, url: none),
)

// A publication's usable identifiers as `(scheme, id)` pairs, schemes
// lowercased; a non-dict `identifiers` or a non-string / empty id is
// skipped.
#let _identifiers(pub) = {
  let ids = pub.at("identifiers", default: none)
  if type(ids) != dictionary { return () }
  ids
    .pairs()
    .filter(((_, id)) => _present_str(id))
    .map(((scheme, id)) => (lower(scheme), id))
}

// Where an unlinked title points: the first linkable identifier, in
// `_identifier_schemes` order.
#let _identifier_url(ids) = {
  let by-scheme = ids.to-dict()
  let hit = _identifier_schemes
    .pairs()
    .find(((scheme, s)) => s.url != none and scheme in by-scheme)
  if hit != none { hit.at(1).url + by-scheme.at(hit.at(0)) }
}

// "DOI 10.1000/182 · arXiv 2101.00001", each value linked when its
// scheme has a URL prefix.
#let _identifier_line(ids) = (
  ids
    .map(((scheme, id)) => {
      let s = _identifier_scheme(scheme)
      [#s.name #if s.url == none { id } else { link(s.url + id, id) }]
    })
    .join[ · ]
)

// JSON Resume 1.7.0 `volume`, `issue` and `pages` as a journal-style
// tail, `12(3), 45–67`: each part optional, taking its punctuation with
// it, and a hyphen or run of hyphens in `pages` set as one en dash.
// `none` when all are absent (a separator-less `join` treats `none` as
// empty).
#let _citation(pub) = {
  let part(key) = {
    let value = pub.at(key, default: none)
    if _present_str(value) { value }
  }
  let issue = part("issue")
  let pages = part("pages")
  (
    (part("volume"), if issue != none { "(" + issue + ")" }).join(),
    if pages != none { pages.replace(regex("-+"), "–") },
  )
    .filter(p => p != none)
    .join(", ")
}

// JSON Resume 1.7.0 `authors`, in published order, joined with ", ";
// the entry matching `owner` (`basics.name`, ignoring case and
// surrounding spaces) is bold, the academic-CV convention.
#let _author_line(pub, owner) = {
  let authors = pub.at("authors", default: ())
  if type(authors) != array { return none }
  let owner-key = if _present_str(owner) { lower(owner.trim()) }
  authors
    .filter(a => type(a) == str)
    .map(a => a.trim())
    .filter(_present_str)
    .map(a => if lower(a) == owner-key { strong(a) } else { a })
    .join(", ")
}

// The line under a publication's title: the publisher, then the
// citation; either stands alone. `none` when both are absent.
#let _source(pub) = {
  let publisher = pub.at("publisher", default: none)
  (if _present(publisher) { publisher }, _citation(pub))
    .filter(p => p != none)
    .join(" ")
}

// Groups appear in first-occurrence order (Typst dicts preserve
// insertion order). Label tables arrive with lowercase keys
// (`_canonical_labels`). Subheading icons resolve via
// `labels.publicationIcons` → `_default_publication_icons` → `file`,
// keyed by the type code.
#let _publications(pubs, (labels, prefs, owner, ..)) = {
  // Drop entries with no usable `name` up front so the section
  // doesn't render an empty bullet, and so an empty section doesn't
  // emit an orphan heading. Matches the filter-first pattern used by
  // awards / projects.
  let valid = pubs.filter(p => _present(p.at("name", default: none)))
  if valid.len() == 0 { return }
  context {
    let body-size = _body_size_state.get()
    let groups = _group_by(valid, _type_code)
    [== #labels.publications]
    let headings = labels.publicationTypes
    // Date and identifier lines share this quieter style.
    let meta = text.with(0.8 * body-size, fill: _body_colour.lighten(35%))
    // Author and source lines share this one, a step stronger.
    let sub = text.with(0.85 * body-size, fill: _body_colour)
    for (code, items) in groups.pairs() [
      #let group-icon = labels.publicationIcons.at(
        code,
        default: _default_publication_icons.at(code, default: "file"),
      )
      // A code with no heading is free text: every entry in its group
      // has a string `type`, so print the first as written. (Not via
      // `default:`, which is evaluated even when the key exists.)
      #let heading = if code in headings { headings.at(code) } else {
        items.first().type
      }
      ==== #icon(group-icon, size: 1.2 * body-size, shift: 0pt) #heading

      #for pub in items [
        #block(breakable: false)[
          #let date = pub.at("releaseDate", default: none)
          #let ids = _identifiers(pub)
          #let url = pub.at("url", default: none)
          #let url = if _present(url) { url } else { _identifier_url(ids) }
          #let title = pub.at("name", default: "")
          #let authors = _author_line(pub, owner)
          #let source = _source(pub)
          #let summary = pub.at("summary", default: none)
          // The optional lines under the title; absent ones drop out, so
          // an empty field can't leave an orphan `\` break.
          #let lines = (
            if authors != none { sub(authors) },
            if source != none { sub(source) },
            if _present(date) { meta(_format_date(date, prefs, labels)) },
            if ids.len() > 0 { meta(_identifier_line(ids)) },
            if _present(summary) { par(summary) },
          ).filter(l => l != none)
          - #styled-link(title, dest: url).
            #for l in lines [\ #l]
        ]
      ]
    ]
  }
}
