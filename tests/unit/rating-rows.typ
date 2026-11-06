// A language whose fluency is blank (`""`, spaces) has no rating and
// no text: `alta()` and the JSON Resume mapping draw its label alone
// on a rating row, as `rating(label, none)` does, rather than panic,
// with nothing after it: no dots, no fallback text.

#import "/lib.typ": alta, altacv, rating
#import "/adapter/json-resume.typ": resume

#let rows = state("rows", ())
#show <alta-rating-label>: it => {
  rows.update(xs => xs + (it,))
  it
}
#let dots = state("dots", 0)
#show selector.or(
  <alta-rating-full>,
  <alta-rating-half>,
  <alta-rating-empty>,
): it => {
  dots.update(n => n + 1)
  it
}
// Every word drawn, to find any after the labels.
#let words = state("words", ())
#show text: it => {
  words.update(xs => xs + (it.text,))
  it
}

#let cv = (
  basics: (name: "Jane Doe"),
  languages: (
    (language: "Irish", fluency: ""),
    (language: "French", fluency: "  "),
  ),
)
// Nothing drawn since the last check but `expected` (blank text, the
// spaces of a blank fluency, aside), and no dot.
#let only(..expected) = context {
  assert.eq(words.get().filter(w => w.trim() != ""), expected.pos())
  assert.eq(dots.get(), 0)
  words.update(())
}

#alta(cv)
#context assert.eq(rows.get(), ([Irish], [French]))
#only("Jane Doe", "Languages", "Irish", "French")

#[
  #show: altacv
  #resume(cv)
  #context assert.eq(rows.get().slice(2), ([Irish], [French]))
  #only("Jane Doe", "Languages", "Irish", "French")
  #rating("German", none)
  #context assert.eq(rows.get().last(), [German])
  #only("German")
]
