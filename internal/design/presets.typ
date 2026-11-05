// The colour themes and the deprecated accent palettes, re-exported
// from `lib.typ`. A theme is `_tokens` overrides (`theme.typ`), any
// subset of them; the built-in ones, one file each under `presets/`,
// set every colour role.

#import "presets/teal.typ"
#import "presets/navy.typ"
#import "presets/crimson.typ"
#import "presets/forest.typ"
#import "presets/plum.typ"
#import "presets/charcoal.typ"
#import "presets/altacv.typ"

/// The built-in themes for `preferences.theme`.
/// -> dictionary
#let themes = (
  teal: teal.theme,
  navy: navy.theme,
  crimson: crimson.theme,
  forest: forest.theme,
  plum: plum.theme,
  charcoal: charcoal.theme,
  altacv: altacv.theme,
)

/// Each built-in theme's heading colour, `altacv` aside. Deprecated:
/// use `themes`.
/// -> dictionary
#let palettes = (
  themes
    .pairs()
    .filter(((k, _)) => k != "altacv")
    .map(((k, t)) => (k, t.colours.heading))
    .to-dict()
)
