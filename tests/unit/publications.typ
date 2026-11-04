// Unit checks for the publication field helpers in
// sections/publications.typ and the `_bib-entry` line builders in
// internal/components/bibliography.typ.

#import "/internal/components/bibliography.typ": (
  _author-line, _author-names, _identifier-groups,
)
#import "/internal/primitives.typ": _join-facts
#import "/internal/design/theme.typ": _default-theme
#import "/sections/publications.typ": (
  _authors, _citation, _identifier-refs, _identifier-url, _identifiers, _source,
)
#import "/tests/unit/_plain.typ": plain

// _identifiers: schemes lowercased; non-dict or unusable ids skipped.
#assert.eq(
  _identifiers((identifiers: (DOI: "10.1/x", isbn: "", pmid: 7))),
  (("doi", "10.1/x"),),
)
#assert.eq(_identifiers((identifiers: "10.1/x")), ())
#assert.eq(_identifiers((:)), ())

// _identifier-refs: conventional names and resolver URLs; unknown
// schemes as given, unlinked.
#assert.eq(
  _identifier-refs((("doi", "10.1/x"), ("hal", "hal-1"))),
  (
    (scheme: "doi", name: "DOI", id: "10.1/x", url: "https://doi.org/10.1/x"),
    (scheme: "hal", name: "hal", id: "hal-1", url: none),
  ),
)

// _identifier-url: the first linkable scheme in DOI, arXiv, PMID
// order, whatever order the data lists them in.
#let url-of(ids) = _identifier-url(_identifier-refs(ids))
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

// _identifier-groups: one `name id` group per ref, joined with ` · `.
#assert.eq(
  plain(_join-facts(_default-theme.separator, .._identifier-groups((
    (name: "DOI", id: "10.1/x", url: "https://doi.org/10.1/x"),
    (name: "hal", id: "hal-1", url: none),
  )))),
  "DOI 10.1/x · hal hal-1",
)
#assert.eq(_identifier-groups(()), ())

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

// _authors: published order, trimmed, unusable entries skipped, each
// of `owners` (normalised, as `ctx.owners` is) flagged ignoring case.
#assert.eq(
  _authors(
    (authors: ("A. Smith", " Jane Doe ", "", 3, "B. Jones")),
    ("jane doe",),
  ),
  (
    (name: "A. Smith", owner: false),
    (name: "Jane Doe", owner: true),
    (name: "B. Jones", owner: false),
  ),
)
#assert.eq(_authors((authors: "A. Smith"), ("jane doe",)), ())
#assert.eq(
  _authors((authors: ("A. Smith",)), ()),
  ((name: "A. Smith", owner: false),),
)
#assert.eq(
  _authors(
    (authors: ("J. Doe", "Jane Smith", "Jane Doe", "A. Smith")),
    ("jane doe", "j. doe", "jane smith"),
  ).map(a => a.owner),
  (true, true, true, false),
)

// _author-names: the owner in bold; _author-line `none` with no authors.
#assert.eq(
  plain(_author-names(_default-theme, (
    (name: "A. Smith", owner: false),
    (name: "jane doe", owner: true),
  ))),
  "A. Smith, *jane doe*",
)
#assert.eq(_author-line(()), none)

// _source: publisher, then citation; either alone.
#assert.eq(_source((publisher: "ACM", volume: "12")), "ACM 12")
#assert.eq(_source((publisher: "ACM")), "ACM")
#assert.eq(_source((:)), none)
