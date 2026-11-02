// Publications, grouped by `type` code (case-insensitive) under
// icon-led subheadings named from `labels.publicationTypes`, or as
// first written for unknown codes. The CV owner is bold among
// `authors`; `identifiers` give an unlinked title somewhere to point.

#import "../internal/state.typ": _body_colour, _body_size_state
#import "../internal/text.typ": _present, _present_str, _string_at, styled-link
#import "../internal/primitives.typ": _group_by
#import "../internal/icons.typ": icon
#import "../internal/dates.typ": _format_date

// Extended via `labels.publicationIcons`; anything unmatched,
// including `patent`, falls back to `file`.
#let _code_publication_icons = (
  article: "newspaper",
  book: "book",
  thesis: "book",
  talk: "microphone",
)

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

#let _identifier_url(ids) = {
  let by-scheme = ids.to-dict()
  let hit = _identifier_schemes
    .pairs()
    .find(((scheme, s)) => s.url != none and scheme in by-scheme)
  if hit != none { hit.at(1).url + by-scheme.at(hit.at(0)) }
}

#let _identifier_line(ids) = (
  ids
    .map(((scheme, id)) => {
      let s = _identifier_scheme(scheme)
      [#s.name #if s.url == none { id } else { link(s.url + id, id) }]
    })
    .join[ · ]
)

// Journal-style `12(3), 45–67`; each part takes its punctuation with
// it, and hyphens in `pages` become one en dash.
#let _citation(pub) = {
  let part(key) = _string_at(pub, key)
  let issue = part("issue")
  let pages = part("pages")
  (
    (part("volume"), if issue != none { "(" + issue + ")" }).join(),
    if pages != none { pages.replace(regex("-+"), "–") },
  )
    .filter(p => p != none)
    .join(", ")
}

// The entry matching `owner` (`basics.name`, ignoring case and
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

#let _source(pub) = {
  let publisher = pub.at("publisher", default: none)
  (if _present(publisher) { publisher }, _citation(pub))
    .filter(p => p != none)
    .join(" ")
}

// Label tables arrive lowercase-keyed (`_canonical_labels`). Icons
// resolve `labels.publicationIcons` → `_code_publication_icons` →
// `file`.
#let _publications(pubs, (labels, prefs, owner, ..)) = {
  // Filter first so an empty section emits no orphan heading.
  let valid = pubs.filter(p => _present(p.at("name", default: none)))
  if valid.len() == 0 { return }
  context {
    let body-size = _body_size_state.get()
    let groups = _group_by(valid, _type_code)
    [== #labels.publications]
    let headings = labels.publicationTypes
    let meta = text.with(0.8 * body-size, fill: _body_colour.lighten(35%))
    let sub = text.with(0.85 * body-size, fill: _body_colour)
    for (code, items) in groups.pairs() [
      #let group-icon = labels.publicationIcons.at(
        code,
        default: _code_publication_icons.at(code, default: "file"),
      )
      // An unknown code's entries all share a string `type`, so print
      // the first as written. Not `default:`, which is evaluated even
      // when the key exists.
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
          // Absent lines drop out so none leaves an orphan `\` break.
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
