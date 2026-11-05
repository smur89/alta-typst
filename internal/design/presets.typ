// The colour themes and the deprecated accent palettes, re-exported
// from `lib.typ`. A theme is `_tokens` overrides (`theme.typ`), any
// subset of them; the built-in ones, one file each under `presets/`,
// set every colour role.
//
// Each built-in theme is tones of one hue, ranked: the `name` its
// deepest, the section titles its namesake, the details (`accent`:
// organisations, pills, dots, icons) a livelier tone, and the rule
// under each title a pale tint, so the title leads rather than its
// line. The text greys lean towards the hue (warm under crimson, cool
// under navy), each at least 4.5:1 on white; every text role survives
// a B&W photocopy.

#import "presets/teal.typ"
#import "presets/navy.typ"
#import "presets/crimson.typ"
#import "presets/forest.typ"
#import "presets/plum.typ"
#import "presets/charcoal.typ"
#import "presets/altacv.typ"

/// The built-in themes for `preferences.theme`: one per hue, and
/// `altacv`, with dark red headings over a gold rule.
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

/// The colour each single-hue theme is named for, its section titles'.
/// Deprecated: use `themes`.
/// -> dictionary
#let palettes = (
  themes
    .pairs()
    .filter(((k, _)) => k != "altacv")
    .map(((k, t)) => (k, t.colours.heading))
    .to-dict()
)
