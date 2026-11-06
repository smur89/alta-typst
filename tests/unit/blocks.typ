// The markup blocks' context logic: an entry's heading level and the
// divider before it. An entry's body is optional; an entry without a
// title leaves no heading but still counts for the divider, after
// `alta()` too.

#import "/lib.typ": alta, altacv, entry

#show: altacv

#let levels = state("entry-levels", ())
#show <alta-internal-entry>: it => {
  context {
    let l = it.level
    levels.update(ls => ls + (l,))
  }
  it
}
#let dividers = state("dividers", 0)
#show divider: it => {
  dividers.update(n => n + 1)
  it
}
// The dividers drawn between two markers.
#let dividers-between(from, to) = (
  dividers.at(locate(to)) - dividers.at(locate(from))
)

= Experience
#entry(title: "A")
#entry(title: "B")[- With a body]
= Publications
== Talks
#entry(title: "C")
#entry(title: "D")
== Articles
#entry(title: "E")
#metadata(none)<titled>

#context assert.eq(levels.at(locate(<titled>)), (2, 2, 3, 3, 3))
// Between A and B, and C and D: not before the first of a section or
// group.
#context assert.eq(dividers.at(locate(<titled>)), 2)

// Untitled entries: one divider between each pair, none before the
// first.
= Untitled
#entry(org: "A")[]
#entry(org: "B")[]
#entry(title: "T")[]
#metadata(none)<untitled>
#context assert.eq(dividers-between(<titled>, <untitled>), 2)

// An entry right after `#alta(cv)` continues its last section, after a
// divider, even when `alta()`'s last entry has no title, so leaves no
// entry heading: `_entry` marks every entry.
#alta((
  basics: (name: "Jane Doe"),
  work: ((name: "Acme Corp"),),
))
#entry(title: "T")[]
#metadata(none)<after-alta>
#context assert.eq(dividers-between(<untitled>, <after-alta>), 1)
