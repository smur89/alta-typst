// `themes` exports vetted preset bundles of preferences that hang
// together visually — accent + font + columnRatio + headerTextAlign.
// Callers spread a theme over their own overrides:
//
//   #alta(cv, preferences: themes.classic)
//   #alta(cv, preferences: themes.modern + (imageSize: 7em))
//
// One document per built-in theme, plus one demonstrating the
// spread-and-override pattern. The modern / minimal theme fonts
// (Inter, Source Sans 3) aren't installed on the CI host, so each
// non-classic theme is rendered with `font` overridden back to
// `Lato` — that keeps the fixture warning-free while still
// exercising the theme spread on every other knob.

#import "../lib.typ": alta, themes

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

#alta(cv, preferences: themes.classic)

#pagebreak()

#alta(cv, preferences: themes.modern + (font: "Lato"))

#pagebreak()

#alta(cv, preferences: themes.minimal + (font: "Lato"))

#pagebreak()

// Spread-and-override: themes are partial dicts, so any preferences
// key — built-in or theme — can be overridden after the spread.
#alta(cv, preferences: themes.modern + (font: "Lato", imageSize: 7em))
