// Unit checks for the publication line builders in
// sections/publications.typ.

#import "/sections/publications.typ": (
  _author_line, _citation, _identifier_line, _identifier_url, _identifiers,
  _source,
)
#import "_plain.typ": plain

// _identifiers: schemes lowercased; non-dict or unusable ids skipped.
#assert.eq(
  _identifiers((identifiers: (DOI: "10.1/x", isbn: "", pmid: 7))),
  (("doi", "10.1/x"),),
)
#assert.eq(_identifiers((identifiers: "10.1/x")), ())
#assert.eq(_identifiers((:)), ())

// _identifier_url: the first linkable scheme in DOI, arXiv, PMID
// order, whatever order the data lists them in.
#assert.eq(
  _identifier_url((("isbn", "978"), ("arxiv", "2101.1"), ("doi", "10.1/x"))),
  "https://doi.org/10.1/x",
)
#assert.eq(
  _identifier_url((("arxiv", "2101.1"),)),
  "https://arxiv.org/abs/2101.1",
)
#assert.eq(_identifier_url((("isbn", "978"),)), none)

// _identifier_line: conventional names, unknown schemes as given.
#assert.eq(
  plain(_identifier_line((("doi", "10.1/x"), ("hal", "hal-1")))),
  "DOI 10.1/x · hal hal-1",
)

// _citation: journal-style tail, each part optional, page hyphens
// set as one en dash.
#assert.eq(_citation((volume: "12", issue: "3", pages: "45--67")), "12(3), 45–67")
#assert.eq(_citation((volume: "12")), "12")
#assert.eq(_citation((issue: "3")), "(3)")
#assert.eq(_citation((pages: "9")), "9")
#assert.eq(_citation((:)), none)

// _author_line: published order, trimmed, unusable entries skipped,
// the owner (ignoring case and spaces) in bold.
#let line = _author_line(
  (authors: ("A. Smith", " jane doe ", "", 3, "B. Jones")),
  "Jane Doe",
)
#assert.eq(plain(line), "A. Smith, jane doe, B. Jones")
#assert(line.children.any(c => c.func() == strong))
#assert.eq(_author_line((authors: "A. Smith"), "Jane Doe"), none)
#assert.eq(plain(_author_line((authors: ("A. Smith",)), none)), "A. Smith")

// _source: publisher, then citation; either alone.
#assert.eq(_source((publisher: "ACM", volume: "12")), "ACM 12")
#assert.eq(_source((publisher: "ACM")), "ACM")
#assert.eq(_source((:)), none)
