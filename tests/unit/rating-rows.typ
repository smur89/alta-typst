// A language whose fluency is blank (`""`, spaces) has no rating and
// no text: `alta()` and the JSON Resume mapping draw its label alone
// on a rating row, as `rating(label, none)` does, rather than panic.

#import "/lib.typ": alta, altacv, rating
#import "/adapter/json-resume.typ": resume

#let rows = state("rows", ())
#show <alta-rating-label>: it => {
  rows.update(xs => xs + (it,))
  it
}

#let cv = (
  basics: (name: "Jane Doe"),
  languages: (
    (language: "Irish", fluency: ""),
    (language: "French", fluency: "  "),
  ),
)

#alta(cv)
#context assert.eq(rows.get(), ([Irish], [French]))

#[
  #show: altacv
  #resume(cv)
  #context assert.eq(rows.get().slice(2), ([Irish], [French]))
  #rating("German", none)
  #context assert.eq(rows.get().last(), [German])
]
