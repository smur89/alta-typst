// Unit checks for how a theme resolves: the template's
// (`altacv.with(theme: ..)`: `_checked-theme`, then `_theme-for`), and
// standalone `alta()`'s, the default theme under `preferences.font` and
// the deprecated `accent` (`_merge-options`, `_token-prefs`).

#import "/internal/data/options.typ": _checked-theme, _merge-options
#import "/internal/design/presets.typ": palettes, themes
#import "/internal/design/theme.typ": (
  _contrast, _default-theme, _theme-for, _token-prefs, _tokens,
)

// The template's theme, checked and built.
#let built(theme) = _theme-for(_checked-theme(theme), (:))
#let roles(theme) = built(theme).colours
// Standalone `alta()`'s, from its preferences.
#let standalone(preferences) = _theme-for(
  (:),
  _token-prefs(_merge-options((:), preferences).prefs),
)

// The built-in themes set every colour role, and only colours: a
// promise of the presets, as a theme may set any subset.
#for (name, theme) in themes {
  assert.eq(
    (theme.keys(), theme.colours.keys().sorted()),
    (("colours",), _tokens.colours.keys().sorted()),
    message: name,
  )
}

// A treatment is a function, and the rest of the treatments keep the
// defaults.
#let treatment(t) = built((treatment: t)).treatment
#assert.eq(treatment((link: strong)).link, strong)
#assert.eq(treatment((link: upper)).owner, strong)

// The default preferences render the theme the state starts from
// outside `alta()` (`context.typ` can't read the preferences), so the
// two can't drift apart, and so does the template's default theme.
#assert.eq(standalone((:)), _default-theme)
#assert.eq(built(themes.teal), _default-theme)

// The default is the teal theme.
#let defaults = roles(themes.teal)
#assert.eq(defaults, standalone((:)).colours)
#assert.eq(defaults.border, defaults.body.lighten(65%))

// Every role a built-in theme sets text in, `secondary` included, is
// at least WCAG AA's 4.5:1 on the white page.
#for (name, theme) in themes {
  let colours = roles(theme)
  for key in colours.keys().filter(k => k not in ("heading-rule", "border")) {
    let ratio = _contrast(colours.at(key))
    assert(ratio >= 4.5, message: name + "." + key + ": " + str(ratio))
  }
}

// `secondary` is `body`'s palest tint, up to 35%, that keeps 4.5:1;
// `body` itself when even that fails.
#assert.eq(roles((colours: (body: black))).secondary, black.lighten(35%))
#assert.eq(roles((colours: (body: luma(160)))).secondary, luma(160))

// A theme's colours spread over a built-in one change only the roles
// they name.
#let tweaked = roles(
  themes.altacv + (colours: (..themes.altacv.colours, body: black)),
)
#assert.eq(tweaked.body, black)
#assert.eq(tweaked.heading-rule, themes.altacv.colours.heading-rule)
#assert.eq(tweaked.secondary, black.lighten(35%))
#assert.eq(roles((colours: (accent: red))).heading, palettes.teal)

// #239: standalone, the deprecated top-level `accent` colours the
// accent roles with one colour.
#let legacy = standalone((accent: palettes.navy)).colours
#for key in ("accent", "heading", "heading-rule", "subheading", "name") {
  assert.eq(legacy.at(key), palettes.navy)
}
#assert.eq(legacy.body, defaults.body)
// The tagline isn't an accent role: 1.8.0 drew it in the emphasis
// grey, never the default theme's teal beside another accent.
#assert.eq(legacy.tagline, defaults.emphasis)

// Any token a theme overrides reaches the built theme, the separators
// and treatments included: nothing in the look is outside it.
#let piped = built((separator: (facts: " | ")))
#assert.eq(piped.separator.facts, " | ")
#assert.eq(piped.separator.items, ", ")

// A theme may set any tokens and only those: the rest, colours
// included, are the default's.
#let partial = built((
  font: "Libertinus Serif",
  type: (headline: (size: 1.3)),
))
#assert.eq(partial.font, "Libertinus Serif")
#assert.eq(partial.type.headline.size, 1.3)
#assert.eq(partial.type.headline.weight, _tokens.type.headline.weight)
#assert.eq(partial.colours.accent, palettes.teal)
#assert.eq(built((colours: (heading: red))).colours.name, _tokens.colours.name)

// Standalone, `preferences.font` overrides the default theme's; `auto`
// (the default) keeps it.
#assert.eq(standalone((:)).font, "Lato")
#assert.eq(standalone((font: "Libertinus Serif")).font, "Libertinus Serif")

// A separator may be content or a symbol, as it's joined into content;
// a weight a name or a number; a space zero.
#assert.eq(_checked-theme((separator: (facts: [ | ]))).separator.facts, [ | ])
#assert.eq(
  _checked-theme((separator: (items: sym.bullet))).separator.items,
  sym.bullet,
)
#assert.eq(
  _checked-theme((type: (title: (weight: 600)))).type.title.weight,
  600,
)
#assert.eq(_checked-theme((space: (xx-small: 0))).space.xx-small, 0)

// A font may be a fallback array of names and `(name, covers)` entries;
// a theme's body weight is the body text's (`_document`).
#assert.eq(
  _checked-theme((
    font: ("Lato", (name: "Noto Sans CJK SC", covers: "latin-in-cjk")),
  ))
    .font
    .len(),
  2,
)
#assert.eq(
  built((type: (body: (weight: "medium")))).type.body.weight,
  "medium",
)
