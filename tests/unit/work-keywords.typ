// `work[].keywords` read leniently, as 1.8.0 (which drew none) read
// them: only an array of text draws tags; any other value draws none
// rather than failing. Standalone `alta()`; the template's mapping is
// in work-keywords-template.typ.

#import "/lib.typ": alta

#alta((
  basics: (name: "Jane Doe"),
  work: (
    (name: "A", keywords: ("Go", "Rust")),
    (name: "B", keywords: "Go"),
    (name: "C", keywords: ("Go", 5)),
    (name: "D", keywords: (Go: 1)),
  ),
))

#context assert.eq(query(<alta-keyword>).len(), 2)
