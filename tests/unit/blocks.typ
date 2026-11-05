// The markup blocks' context logic: an entry's heading level and the
// divider before it.

#import "/lib.typ": altacv, entry

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

= Experience
#entry(title: "A")[]
#entry(title: "B")[]
= Publications
== Talks
#entry(title: "C")[]
#entry(title: "D")[]
== Articles
#entry(title: "E")[]

#context assert.eq(levels.final(), (2, 2, 3, 3, 3))
// Between A and B, and C and D: not before the first of a section or
// group.
#context assert.eq(dividers.final(), 2)
