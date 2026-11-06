// The spacing the template sets for a CV laid out in it, as `alta()`
// spaces its own: the columns' gutter for a `grid`, and the intro's
// block around `<alta-intro>`. Set rules, so a user's after the
// template win.

#import "/lib.typ": altacv, themes

#let gutters = state("gutters", ())
#show grid: it => {
  gutters.update(gs => gs + (it.column-gutter,))
  it
}
#let intros = state("intros", ())
#show <alta-intro>: it => {
  intros.update(xs => xs + ((it.above, it.below),))
  it
}

#[
  #show: altacv.with(theme: themes.navy)
  // The theme's 12pt gutter; the paragraph spacing (0.8em) plus the
  // theme's intro spacing (0.8em above, 0.3em below).
  #grid(columns: 2)[A][B]
  #block[Summary]<alta-intro>
  #context assert.eq(gutters.get(), ((12pt,),))
  #context assert.eq(intros.get(), ((1.6em, 1.1em),))

  #set grid(column-gutter: 2pt)
  #show <alta-intro>: set block(above: 0pt, below: 0pt)
  #grid(columns: 2)[A][B]
  #block[Summary]<alta-intro>
  #context assert.eq(gutters.get().last(), (2pt,))
  #context assert.eq(intros.get().last(), (0pt, 0pt))
]
// Outside the template, Typst's own.
#grid(columns: 2)[A][B]
#context assert.eq(gutters.get().last(), ())
