// Publications, grouped by `type` code (case-insensitive) under
// icon-led subheadings named from `labels.publication-types`, or as
// first written for unknown codes. The CV owner is bold among
// `authors`; `identifiers` give an unlinked title somewhere to point.
// Helpers shape the fields into data; `_bib-entry` lays them out.

#import "../internal/util/fields.typ": _field, _string-at
#import "../internal/util/values.typ": _group-by
#import "../internal/data/cv.typ": (
  _authors, _entry-type, _identifier-refs, _identifier-url, _identifiers,
)
#import "../internal/primitives.typ": _icon-heading
#import "../internal/components/bibliography.typ": _bib-entry
#import "../internal/components/frame.typ": _grouped-section

// `type` arrives trimmed (`_canonical-cv`); lowercasing makes `Talk`
// and `talk` share a subheading, and untyped entries join `article`.
#let _type-code(pub) = {
  let type = _entry-type(pub)
  if type != none { lower(type) } else { "article" }
}

#let _render-publication(pub, (format-date, owners, ..)) = {
  let refs = _identifier-refs(_identifiers(pub))
  let url = _field(pub, "url")
  _bib-entry(
    pub.name,
    url: if url != none { url } else { _identifier-url(refs) },
    authors: _authors(pub, owners),
    publisher: _field(pub, "publisher"),
    citation: (
      volume: _string-at(pub, "volume"),
      issue: _string-at(pub, "issue"),
      pages: _string-at(pub, "pages"),
    ),
    date: format-date(_field(pub, "release-date")),
    identifiers: refs,
    summary: _field(pub, "summary"),
  )
}

// `publication-types` and `publication-icons` arrive lowercase-keyed
// (`_canonical-labels`, `_canonical-preferences`); a code with no icon
// gets `file`. A list, so nothing between entries.
#let _publications(pubs, ctx) = {
  let (labels, prefs, ..) = ctx
  let headings = labels.publication-types
  _grouped-section(
    labels.publications,
    _group-by(pubs, _type-code),
    (code, items) => {
      let group-icon = prefs.publication-icons.at(code, default: "file")
      // An unknown code's entries all share a string `type`, so print
      // the first as written. Not `default:`, which is evaluated even
      // when the key exists.
      let heading = if code in headings { headings.at(code) } else {
        items.first().type
      }
      _icon-heading(group-icon, heading)
    },
    pub => _render-publication(pub, ctx),
    separator: none,
  )
}
