// For fixtures about links, which a render can't show: a linked and a
// plain entry look the same. Asserts the link destinations since the
// previous `assert-links` (or the start), in order, so one call follows
// each document whatever its page count; tytanic fails the test on a
// failed `assert`.
#let assert-links(expected) = [#context {
  let previous = query(
    selector(<alta-test-links>).before(here(), inclusive: false),
  )
  let links = if previous == () { selector(link) } else {
    selector(link).after(previous.last().location())
  }
  assert.eq(query(links.before(here())).map(l => l.dest), expected)
}<alta-test-links>]
