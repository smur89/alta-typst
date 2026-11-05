// An entry right after `#alta(cv)` continues its last section, after a
// divider, even when `alta()`'s last entry has no title, so leaves no
// entry heading: `_entry` marks every entry.

#import "/lib.typ": alta, altacv, entry

#show: altacv

#let dividers = state("dividers", 0)
#show divider: it => {
  dividers.update(n => n + 1)
  it
}

#alta((
  basics: (name: "Jane Doe"),
  work: ((name: "Acme Corp"),),
))
#entry(title: "T")[]

#context assert.eq(dividers.final(), 1)
