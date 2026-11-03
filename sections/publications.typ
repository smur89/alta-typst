// Publications, grouped by `type` code (case-insensitive) under
// icon-led subheadings named from `labels.publicationTypes`, or as
// first written for unknown codes. The CV owner is bold among
// `authors`; `identifiers` give an unlinked title somewhere to point.
// Helpers shape the fields into data; `_bib-entry` lays them out.

#import "../internal/util/fields.typ": _field, _string-at
#import "../internal/util/values.typ": _group-by, _join-present, _present-str
#import "../internal/primitives.typ": _icon-heading
#import "../internal/components/bibliography.typ": _bib-entry
#import "../internal/components/frame.typ": _grouped-section

// `type` arrives trimmed (`_canonical-cv`); lowercasing makes `Talk`
// and `talk` share a subheading, and untyped entries join `article`.
#let _type-code(pub) = {
  let raw = _string-at(pub, "type")
  if raw != none { lower(raw) } else { "article" }
}

// Scheme names are proper nouns, so not labels. Order matters: an
// unlinked title takes the first linkable scheme listed.
#let _identifier-schemes = (
  doi: (name: "DOI", url: "https://doi.org/"),
  arxiv: (name: "arXiv", url: "https://arxiv.org/abs/"),
  pmid: (name: "PMID", url: "https://pubmed.ncbi.nlm.nih.gov/"),
  isbn: (name: "ISBN", url: none),
)
#let _identifier-scheme(scheme) = _identifier-schemes.at(
  scheme,
  default: (name: scheme, url: none),
)

#let _identifiers(pub) = {
  let ids = pub.at("identifiers", default: none)
  if type(ids) != dictionary { return () }
  ids
    .pairs()
    .filter(((_, id)) => _present-str(id))
    .map(((scheme, id)) => (lower(scheme), id))
}

// One `(scheme, name, id, url)` per identifier, `url` being `none`
// for a scheme that doesn't link.
#let _identifier-refs(ids) = ids.map(((scheme, id)) => {
  let s = _identifier-scheme(scheme)
  (scheme: scheme, name: s.name, id: id, url: if s.url != none { s.url + id })
})

// An unlinked title's destination: the first linkable ref in
// `_identifier-schemes` order, whatever order the data lists them in.
// Of two refs sharing a scheme (`DOI` and `doi`), the last wins.
#let _identifier-url(refs) = {
  let linkable = refs.rev().filter(r => r.url != none)
  let hit = _identifier-schemes
    .keys()
    .map(k => linkable.find(r => r.scheme == k))
    .find(r => r != none)
  if hit != none { hit.url }
}

// Journal-style `12(3), 45–67`; each part takes its punctuation with
// it, and hyphens in `pages` become one en dash.
#let _citation(pub) = {
  let part(key) = _string-at(pub, key)
  let issue = part("issue")
  let pages = part("pages")
  _join-present(
    (
      (part("volume"), if issue != none { "(" + issue + ")" }).join(),
      if pages != none { pages.replace(regex("-+"), "–") },
    ),
    ", ",
  )
}

// `authors` in published order, trimmed, unusable entries dropped,
// each flagged when it's `owner` (`basics.name`, ignoring case and
// surrounding spaces). Empty when `authors` isn't an array.
#let _authors(pub, owner) = {
  let authors = pub.at("authors", default: ())
  if type(authors) != array { return () }
  let owner-key = if _present-str(owner) { lower(owner.trim()) }
  authors
    .filter(a => type(a) == str)
    .map(a => a.trim())
    .filter(_present-str)
    .map(a => (name: a, owner: lower(a) == owner-key))
}

#let _source(pub) = _join-present(
  (_field(pub, "publisher"), _citation(pub)),
  " ",
)

#let _render-publication(pub, (format-date, owner, ..)) = {
  let refs = _identifier-refs(_identifiers(pub))
  let url = _field(pub, "url")
  _bib-entry(
    pub.name,
    url: if url != none { url } else { _identifier-url(refs) },
    authors: _authors(pub, owner),
    source: _source(pub),
    date: format-date(_field(pub, "releaseDate")),
    identifiers: refs,
    summary: _field(pub, "summary"),
  )
}

// `publicationTypes` and `publicationIcons` arrive lowercase-keyed
// (`_canonical-labels`, `_canonical-preferences`); a code with no icon
// gets `file`. A list, so no dividers between entries.
#let _publications(pubs, ctx) = {
  let (labels, prefs, ..) = ctx
  let headings = labels.publicationTypes
  _grouped-section(
    labels.publications,
    _group-by(pubs.filter(p => _field(p, "name") != none), _type-code),
    (code, items) => {
      let group-icon = prefs.publicationIcons.at(code, default: "file")
      // An unknown code's entries all share a string `type`, so print
      // the first as written. Not `default:`, which is evaluated even
      // when the key exists.
      let heading = if code in headings { headings.at(code) } else {
        items.first().type
      }
      _icon-heading(group-icon, heading)
    },
    pub => _render-publication(pub, ctx),
    dividers: false,
  )
}
