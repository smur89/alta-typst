// Unit checks for the publication field helpers in
// sections/publications.typ and the `_bib_entry` line builders in
// internal/components/bibliography.typ.

#import "/sections/publications.typ": (
  _authors, _citation, _identifier_refs, _identifier_url, _identifiers, _source,
)
#import "/internal/components/bibliography.typ": _author_line, _identifier_line
#import "_plain.typ": plain

// _identifiers: schemes lowercased; non-dict or unusable ids skipped.
#assert.eq(
  _identifiers((identifiers: (DOI: "10.1/x", isbn: "", pmid: 7))),
  (("doi", "10.1/x"),),
)
#assert.eq(_identifiers((identifiers: "10.1/x")), ())
#assert.eq(_identifiers((:)), ())

// _identifier_refs: conventional names and resolver URLs; unknown
// schemes as given, unlinked.
#assert.eq(
  _identifier_refs((("doi", "10.1/x"), ("hal", "hal-1"))),
  (
    (scheme: "doi", name: "DOI", id: "10.1/x", url: "https://doi.org/10.1/x"),
    (scheme: "hal", name: "hal", id: "hal-1", url: none),
  ),
)

// _identifier_url: the first linkable scheme in DOI, arXiv, PMID
// order, whatever order the data lists them in.
#let url-of(ids) = _identifier_url(_identifier_refs(ids))
#assert.eq(
  url-of((("isbn", "978"), ("arxiv", "2101.1"), ("doi", "10.1/x"))),
  "https://doi.org/10.1/x",
)
#assert.eq(url-of((("arxiv", "2101.1"),)), "https://arxiv.org/abs/2101.1")
#assert.eq(url-of((("isbn", "978"),)), none)
// Two keys lowercased to one scheme: the last listed wins.
#assert.eq(
  url-of((("doi", "10.1/a"), ("doi", "10.1/b"))),
  "https://doi.org/10.1/b",
)

// _identifier_line: one `name id` per ref, joined with ` · `.
#assert.eq(
  plain(_identifier_line((
    (name: "DOI", id: "10.1/x", url: "https://doi.org/10.1/x"),
    (name: "hal", id: "hal-1", url: none),
  ))),
  "DOI 10.1/x · hal hal-1",
)
#assert.eq(_identifier_line(()), none)

// _citation: journal-style tail, each part optional, page hyphens
// set as one en dash.
#assert.eq(
  _citation((volume: "12", issue: "3", pages: "45--67")),
  "12(3), 45–67",
)
#assert.eq(_citation((volume: "12")), "12")
#assert.eq(_citation((issue: "3")), "(3)")
#assert.eq(_citation((pages: "9")), "9")
#assert.eq(_citation((:)), none)

// _authors: published order, trimmed, unusable entries skipped, the
// owner (ignoring case and spaces) flagged.
#assert.eq(
  _authors(
    (authors: ("A. Smith", " jane doe ", "", 3, "B. Jones")),
    "Jane Doe",
  ),
  (
    (name: "A. Smith", owner: false),
    (name: "jane doe", owner: true),
    (name: "B. Jones", owner: false),
  ),
)
#assert.eq(_authors((authors: "A. Smith"), "Jane Doe"), ())
#assert.eq(
  _authors((authors: ("A. Smith",)), none),
  ((name: "A. Smith", owner: false),),
)

// _author_line: the owner in bold.
#assert.eq(
  plain(_author_line((
    (name: "A. Smith", owner: false),
    (name: "jane doe", owner: true),
  ))),
  "A. Smith, *jane doe*",
)
#assert.eq(_author_line(()), none)

// _source: publisher, then citation; either alone.
#assert.eq(_source((publisher: "ACM", volume: "12")), "ACM 12")
#assert.eq(_source((publisher: "ACM")), "ACM")
#assert.eq(_source((:)), none)
