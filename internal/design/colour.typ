// Colour helpers shared by the theme (`theme.typ`) and the built-in
// presets (`presets/`), which `theme.typ` reads its default from.

// A built-in theme's colours: tones of one hue (`presets.typ`), the
// group titles in its `accent` and the tagline in its `emphasis`.
#let _hue-colours(colours) = (
  colours + (subheading: colours.accent, tagline: colours.emphasis)
)

// WCAG's contrast ratio of `c` on the white page.
#let _contrast(c) = {
  let (r, g, b) = rgb(c)
    .components(alpha: false)
    .map(v => {
      let x = v / 100%
      if x <= 0.04045 { x / 12.92 } else { calc.pow((x + 0.055) / 1.055, 2.4) }
    })
  1.05 / (0.2126 * r + 0.7152 * g + 0.0722 * b + 0.05)
}
