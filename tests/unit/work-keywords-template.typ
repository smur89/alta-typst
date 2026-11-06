// `work[].keywords` read leniently in the template's mapping, as
// work-keywords.typ checks standalone `alta()`: only an array of text
// draws pills.

#import "/lib.typ": alta, altacv

#show: altacv

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
