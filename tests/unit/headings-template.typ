// The template styles a level-3 heading only as an entry: an unlabelled
// `===` the user writes keeps Typst's own style (the body's colour,
// bold, at the body's size), not a group's.

#import "/lib.typ": altacv, themes

#show: altacv.with(theme: themes.navy)

#let styles = state("heading-styles", ())
#let probe = context {
  let style = (fill: text.fill, weight: text.weight, size: text.size)
  styles.update(s => s + (style,))
}

#probe
== #probe Group
=== #probe Plain
#context {
  let (body, group, plain) = styles.final()
  assert.ne(plain.fill, group.fill, message: "a `===` took the group's fill")
  assert.eq(plain, body + (weight: "bold"))
}
