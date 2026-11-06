// `cv-columns`: the left column beside the right, the gutter the
// theme's, read where it's laid out; one column when the ratio is 1 or
// there's no right column.

#import "/lib.typ": altacv, cv-columns, themes

#let grids = state("grids", ())
#show grid: it => {
  grids.update(gs => gs + ((it.columns, it.column-gutter),))
  it
}

#show: altacv.with(theme: themes.navy)

#cv-columns[Left][Right]
#context assert.eq(grids.get(), (((0.65fr, 0.35fr), (12pt,)),))
#cv-columns([Left], [Right], ratio: 0.5)
#context assert.eq(grids.get().last(), ((0.5fr, 0.5fr), (12pt,)))
// One column: no grid.
#cv-columns([Left], none)
#cv-columns([Left], [Right], ratio: 1)
#context assert.eq(grids.get().len(), 2)
