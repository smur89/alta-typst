// The spacing the template sets for a CV laid out in it, as `alta()`
// spaces its own: the intro's block around `<alta-intro>`. A show-set
// rule, so a user's after the template wins.

#import "/lib.typ": altacv, themes

#let intros = state("intros", ())
#show <alta-intro>: it => {
  intros.update(xs => xs + ((it.above, it.below),))
  it
}

#[
  #show: altacv.with(theme: themes.navy)
  // The paragraph spacing (0.8em) plus the theme's intro spacing
  // (0.8em above, 0.3em below).
  #block[Summary]<alta-intro>
  #context assert.eq(intros.get(), ((1.6em, 1.1em),))

  #show <alta-intro>: set block(above: 0pt, below: 0pt)
  #block[Summary]<alta-intro>
  #context assert.eq(intros.get().last(), (0pt, 0pt))
]
