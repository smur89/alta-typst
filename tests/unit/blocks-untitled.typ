// An entry without a title leaves no heading but still counts for the
// divider: one between each pair of entries, none before the first.

#import "/lib.typ": altacv, entry

#show: altacv

#let dividers = state("dividers", 0)
#show divider: it => {
  dividers.update(n => n + 1)
  it
}

= Experience
#entry(org: "A")[]
#entry(org: "B")[]
#entry(title: "T")[]

#context assert.eq(dividers.final(), 2)
