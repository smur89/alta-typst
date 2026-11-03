// Publications, grouped by `type` code (case-insensitive) under
// icon-led subheadings named from `labels.publicationTypes`, or as
// first written for unknown codes. The CV owner is bold among
// `authors`; `identifiers` give an unlinked title somewhere to point.
// Helpers shape the fields into data; `_bib_entry` lays them out.

#import "../internal/util/dates.typ": _format_date
#import "../internal/util/fields.typ": (
  _field, _join_present, _present_str, _string_at,
)
#import "../internal/primitives.typ": _icon_heading
#import "../internal/components/bibliography.typ": _bib_entry
#import "../internal/components/frame.typ": _group_by, _grouped_section

// `type` arrives trimmed (`_canonical_cv`); lowercasing makes `Talk`
// and `talk` share a subheading, and untyped entries join `article`.
#let _type_code(pub) = {
  let raw = _string_at(pub, "type")
  if raw != none { lower(raw) } else { "article" }
}

// Scheme names are proper nouns, so not labels. Order matters: an
// unlinked title takes the first linkable scheme listed.
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

#let _identifiers(pub) = {
  let ids = pub.at("identifiers", default: none)
  if type(ids) != dictionary { return () }
  ids
    .pairs()
    .filter(((_, id)) => _present_str(id))
    .map(((scheme, id)) => (lower(scheme), id))
}

// One `(scheme, name, id, url)` per identifier, `url` being `none`
// for a scheme that doesn't link.
#let _identifier_refs(ids) = ids.map(((scheme, id)) => {
  let s = _identifier_scheme(scheme)
  (scheme: scheme, name: s.name, id: id, url: if s.url != none { s.url + id })
})

// An unlinked title's destination: the first linkable ref in
// `_identifier_schemes` order, whatever order the data lists them in.
// Of two refs sharing a scheme (`DOI` and `doi`), the last wins.
#let _identifier_url(refs) = {
  let linkable = refs.rev().filter(r => r.url != none)
  let hit = _identifier_schemes
    .keys()
    .map(k => linkable.find(r => r.scheme == k))
    .find(r => r != none)
  if hit != none { hit.url }
}

// Journal-style `12(3), 45–67`; each part takes its punctuation with
// it, and hyphens in `pages` become one en dash.
#let _citation(pub) = {
  let part(key) = _string_at(pub, key)
  let issue = part("issue")
  let pages = part("pages")
  _join_present(
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
  let owner-key = if _present_str(owner) { lower(owner.trim()) }
  authors
    .filter(a => type(a) == str)
    .map(a => a.trim())
    .filter(_present_str)
    .map(a => (name: a, owner: lower(a) == owner-key))
}

#let _source(pub) = _join_present(
  (_field(pub, "publisher"), _citation(pub)),
  " ",
)

#let _render_publication(pub, (labels, prefs, owner, ..)) = {
  let refs = _identifier_refs(_identifiers(pub))
  let url = _field(pub, "url")
  _bib_entry(
    pub.name,
    url: if url != none { url } else { _identifier_url(refs) },
    authors: _authors(pub, owner),
    source: _source(pub),
    date: _format_date(_field(pub, "releaseDate"), prefs, labels),
    identifiers: refs,
    summary: _field(pub, "summary"),
  )
}

// `publicationTypes` and `publicationIcons` arrive lowercase-keyed
// (`_canonical_labels`, `_canonical_preferences`); a code with no icon
// gets `file`. A list, so no dividers between entries.
#let _publications(pubs, ctx) = {
  let (labels, prefs, ..) = ctx
  let headings = labels.publicationTypes
  _grouped_section(
    labels.publications,
    _group_by(pubs.filter(p => _field(p, "name") != none), _type_code),
    (code, items) => {
      let group-icon = prefs.publicationIcons.at(code, default: "file")
      // An unknown code's entries all share a string `type`, so print
      // the first as written. Not `default:`, which is evaluated even
      // when the key exists.
      let heading = if code in headings { headings.at(code) } else {
        items.first().type
      }
      _icon_heading(group-icon, heading)
    },
    pub => _render_publication(pub, ctx),
    dividers: false,
  )
}
