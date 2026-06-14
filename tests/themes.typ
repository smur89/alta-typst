// One page per built-in theme + a final page demonstrating
// spread-and-override. `font` is forced back to `Lato` for the
// non-classic themes because CI lacks `Inter` / `Source Sans 3`,
// so the snapshot stays warning-free while every other theme knob
// (accent, columnRatio, headerTextAlign) still gets exercised.

#import "../lib.typ": alta, themes

// Pin the declared font on each theme so a typo in `internal/presets.typ`
// (e.g. `"Intr"`) is caught here rather than silently falling back to
// the system default and producing an identical-looking snapshot.
#assert.eq(themes.classic.font, "Lato")
#assert.eq(themes.modern.font, "Inter")
#assert.eq(themes.minimal.font, "Source Sans 3")

#let cv = (
  basics: (
    name: "Sample User",
    label: "Engineer",
    email: "sample@example.com",
    location: "Dublin, Ireland",
  ),
  work: (
    (
      name: "Acme",
      position: "Engineer",
      startDate: "Jan 2024",
      highlights: ([Shipped things.],),
    ),
  ),
  skills: ((name: "Languages", keywords: ("Scala", "Python")),),
)

#for (i, key) in themes.keys().enumerate() {
  if i > 0 { pagebreak() }
  let theme = themes.at(key)
  // `font: "Lato"` is a no-op for `classic` and the CI-host workaround
  // for `modern` / `minimal`; merging unconditionally keeps the loop
  // body uniform across themes.
  alta(cv, preferences: theme + (font: "Lato"))
}

#pagebreak()

// Spread-and-override: themes are partial dicts, so any preferences
// key — built-in or theme — can be overridden after the spread.
#alta(cv, preferences: themes.modern + (font: "Lato", imageSize: 7em))
