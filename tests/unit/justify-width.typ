// Justified prose in the template stretches to the column, not to its
// own widest line: a line ended by `linebreak(justify: true)` ends at
// the column's right edge, in the intro (`alta()` through the
// mapping), an entry's body and a publication's summary. Each block
// is full width; at `width: auto` it would shrink to the text and
// nothing would stretch. The page is 10cm wide with 1cm margins, so
// the edge is at 9cm.

#import "/lib.typ": alta, altacv, entry, publication

#show: altacv
#set page(width: 10cm, height: auto, margin: 1cm)
#set document(title: "Jane Doe", author: "Jane Doe")
#set par(justify: true)

// A short line, justified up to a marker where it breaks.
#let line(
  key,
) = [Alpha Beta#metadata(key)<line-end>#linebreak(justify: true)Gamma]

#alta((basics: (name: "Jane Doe", summary: line("intro"))))

= Experience
#entry(title: "Engineer")[#line("entry")]

= Publications
#publication(title: "Paper")[#line("publication")]

#context for m in query(<line-end>) {
  let x = m.location().position().x
  assert(
    calc.abs((x - 9cm).to-absolute()) < 0.5pt,
    message: m.value + " line ends at " + repr(x) + ", not the column's edge",
  )
}
#context assert.eq(query(<line-end>).len(), 3)
