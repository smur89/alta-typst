// Unit checks for how `preferences.colours` resolves, through
// `_merge-options` and `_colour-roles`, the sequence `alta()` runs.

#import "/internal/data/options.typ": _merge-options
#import "/internal/design/presets.typ": palettes
#import "/internal/design/theme.typ": _colour-roles

#let roles(prefs) = _colour-roles(_merge-options((:), prefs).prefs.colours)

// The `auto` roles follow the accent, `tagline` the emphasis.
#let defaults = roles((:))
#for key in ("heading", "headingRule", "subheading", "name") {
  assert.eq(defaults.at(key), palettes.teal)
}
#assert.eq(defaults.tagline, defaults.emphasis)
#assert.eq(defaults.border, defaults.body.lighten(65%))

// A partial `colours` keeps the other defaults, and the followers
// track a set accent.
#let navy = roles((colours: (accent: palettes.navy, heading: red)))
#assert.eq(navy.heading, red)
#assert.eq(navy.name, palettes.navy)
#assert.eq(navy.body, defaults.body)

// A set body carries `secondary` and `border` with it.
#assert.eq(roles((colours: (body: black))).secondary, black.lighten(35%))

// #239: the deprecated top-level `accent` is `colours.accent`, which
// wins when both are set.
#assert.eq(roles((accent: palettes.navy)).heading, palettes.navy)
#assert.eq(
  roles((accent: palettes.navy, colours: (accent: palettes.plum))).accent,
  palettes.plum,
)
