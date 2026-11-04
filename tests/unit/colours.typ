// Unit checks for how `preferences.theme` and `preferences.colours`
// resolve, through `_merge-options` and `_theme-for`, the sequence
// `alta()` runs.

#import "/internal/data/options.typ": _merge-options
#import "/internal/design/presets.typ": palettes, themes
#import "/internal/data/defaults.typ": _default-preferences
#import "/internal/design/theme.typ": _colour-role-names, _theme-for, _tokens

#let roles(preferences) = {
  let prefs = _merge-options((:), preferences).prefs
  _theme-for(prefs.theme, prefs.colours).colours
}

// Every theme sets every role, and nothing else.
#for (name, theme) in themes {
  assert.eq(
    theme.colours.keys().sorted(),
    _colour-role-names.sorted(),
    message: name,
  )
}

// The default theme preference is `_tokens`' own colours, which the
// theme state starts from outside `alta()` (`context.typ` can't read
// the preferences), so the two can't drift apart.
#assert.eq(_default-preferences.theme, (colours: _tokens.colours))

// The default is the teal theme; a single-accent theme colours the
// headings, their rules, the group titles and the name with its accent.
#let defaults = roles((:))
#for key in ("accent", "heading", "headingRule", "subheading", "name") {
  assert.eq(defaults.at(key), palettes.teal)
}
#assert.eq(defaults.tagline, defaults.emphasis)
#assert.eq(defaults.border, defaults.body.lighten(65%))

// `colours` sets only the roles it names, over the chosen theme.
#let tweaked = roles((theme: themes.altacv, colours: (body: black)))
#assert.eq(tweaked.body, black)
#assert.eq(tweaked.headingRule, themes.altacv.colours.headingRule)
#assert.eq(tweaked.secondary, black.lighten(35%))
#assert.eq(roles((colours: (accent: red))).heading, palettes.teal)

// #239: the deprecated top-level `accent` colours the accent roles as
// a single-accent theme does, beneath the caller's `colours`.
#let legacy = roles((accent: palettes.navy))
#for key in ("accent", "heading", "headingRule", "subheading", "name") {
  assert.eq(legacy.at(key), palettes.navy)
}
#assert.eq(legacy.body, defaults.body)
#assert.eq(
  roles((accent: palettes.navy, colours: (heading: red))).heading,
  red,
)
