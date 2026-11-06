// The spacing the template sets for a CV laid out in it, as `alta()`
// spaces its own: the intro's block around `<alta-intro>`, a
// paragraph's spacing, merging with its neighbours', and the theme's
// intro spacing inside it, adding to it. A show-set rule, so a user's
// after the template wins.

#import "/lib.typ": alta, altacv, themes

#let intros = state("intros", ())
#show <alta-intro>: it => {
  intros.update(xs => xs + ((it.above, it.below, it.inset),))
  it
}

#[
  #show: altacv.with(theme: themes.navy)
  #block[Summary]<alta-intro>
  #context assert.eq(intros.get(), (
    (0.8em, 0.8em, (top: 0.8em, bottom: 0.3em)),
  ))

  #show <alta-intro>: set block(above: 0pt, below: 0pt, inset: 0pt)
  #block[Summary]<alta-intro>
  #context assert.eq(intros.get().last(), (0pt, 0pt, 0pt))
]
#pagebreak()

// Where the intro puts the first section, as `alta()` put it before
// it drew through the mapping (measured then): under a header of a
// name alone, beside a second column, and in a single column.
#show: altacv
#let cv = (
  basics: (name: "X", summary: "Sum"),
  work: ((name: "Acme", position: "Engineer"),),
  skills: ((name: "Go", keywords: ("x",)),),
)
#alta(cv)
#pagebreak()
#alta(cv, preferences: (column-ratio: 1))
#pagebreak()
#alta(cv, preferences: (right-column-sections: ()))
#context {
  let first(page) = {
    query(heading.where(level: 1))
      .find(h => h.location().page() == page)
      .location()
      .position()
      .y
  }
  // To the hundredth of a point, as the values were measured.
  let ys = (2, 3, 4).map(p => calc.round(first(p).pt(), digits: 2))
  assert.eq(ys, (98.76, 105.16, 105.16))
}
