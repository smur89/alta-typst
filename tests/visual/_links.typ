// For fixtures about links, which a render can't show: a linked and a
// plain entry look the same. Asserts `page`'s link destinations, in
// order; tytanic fails the test on a failed `assert`.
#let assert-links(page, expected) = context assert.eq(
  query(link).filter(l => l.location().page() == page).map(l => l.dest),
  expected,
)
