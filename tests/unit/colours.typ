// Unit checks for how `preferences.theme`, `preferences.colours` and
// `preferences.font` resolve, through `_merge-options`, `_token-prefs`
// and `_theme-for`, the sequence `alta()` runs.

#import "/internal/data/options.typ": _merge-options
#import "/internal/design/presets.typ": palettes, themes
#import "/internal/design/styles.typ": _treatments
#import "/internal/design/theme.typ": (
  _default-theme, _theme-for, _token-prefs, _tokens, _treatment-names,
)

#let built(preferences) = {
  let prefs = _merge-options((:), preferences).prefs
  _theme-for(prefs.theme, _token-prefs(prefs))
}
#let roles(preferences) = built(preferences).colours

// The built-in themes set every colour role, and only colours: a
// promise of the presets, as a theme may set any subset.
#for (name, theme) in themes {
  assert.eq(
    (theme.keys(), theme.colours.keys().sorted()),
    (("colours",), _tokens.colours.keys().sorted()),
    message: name,
  )
}

// The theme validation's names are the ones `_treat` applies.
#assert.eq(_treatments.keys().sorted(), _treatment-names.sorted())

// The default preferences render the theme the state starts from
// outside `alta()` (`context.typ` can't read the preferences), so the
// two can't drift apart.
#assert.eq(built((:)), _default-theme)

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

// Any token a theme overrides reaches the built theme, the separators
// and treatments included: nothing in the look is outside it.
#let piped = _theme-for((separator: (facts: " | ")), (:))
#assert.eq(piped.separator.facts, " | ")
#assert.eq(piped.separator.items, ", ")
#assert.eq(
  _theme-for((treatment: (link: "strong")), (:)).treatment.link,
  "strong",
)

// A theme may set any tokens and only those: the rest, colours
// included, are the default's.
#let partial = built((
  theme: (font: "Libertinus Serif", type: (headline: (size: 1.3))),
))
#assert.eq(partial.font, "Libertinus Serif")
#assert.eq(partial.type.headline.size, 1.3)
#assert.eq(partial.type.headline.weight, _tokens.type.headline.weight)
#assert.eq(partial.colours.accent, palettes.teal)
#assert.eq(
  built((theme: (colours: (heading: red)))).colours.name,
  palettes.teal,
)

// `preferences.font` overrides the theme's; `auto` (the default) keeps
// it.
#assert.eq(built((:)).font, "Lato")
#assert.eq(built((theme: (font: "Libertinus Serif"))).font, "Libertinus Serif")
#assert.eq(
  built((theme: (font: "Libertinus Serif"), font: "Lato")).font,
  "Lato",
)

// A separator may be content or a symbol, as it's joined into content;
// a weight a name or a number; a space zero.
#let valid(theme) = _merge-options((:), (theme: theme)).prefs.theme
#assert.eq(valid((separator: (facts: [ | ]))).separator.facts, [ | ])
#assert.eq(valid((separator: (items: sym.bullet))).separator.items, sym.bullet)
#assert.eq(valid((type: (title: (weight: 600)))).type.title.weight, 600)
#assert.eq(valid((space: (xx-small: 0))).space.xx-small, 0)
