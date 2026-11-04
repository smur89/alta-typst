// altacv's three non-spec fields read from JSON Resume's `custom`
// object, namespaced `altacv` (#242): `custom.altacv.focusAreas` at
// the root, `languages[].custom.altacv.rating` and
// `awards[].custom.altacv.url`. The top-level forms (`focusAreas`,
// `languages[].rating`, `awards[].url`) are deprecated but still read.
//
// Three documents (custom-altacv-deprecated checks the deprecated
// forms alone render the same as document 1):
//   1. Every field via `custom.altacv` only.
//   2. Both forms on every field with different values — the
//      `custom.altacv` value wins (focus areas, 4.5 dots, `/custom` link).
//   3. `custom` carrying other tools' namespaces (root, `basics` and
//      entries) alongside altacv's — ignored, nothing extra renders.

#import "/lib.typ": alta
#import "/tests/fixtures/custom-altacv.typ": basics, namespaced

#alta(namespaced)

#pagebreak()

#alta((
  basics: basics,
  focusAreas: ([Deprecated top-level item — should not render.],),
  custom: (altacv: (focusAreas: ([From custom.altacv — wins.],))),
  languages: (
    // custom (4.5) beats the deprecated rating (1), which beats fluency.
    (
      language: "German",
      fluency: "Elementary",
      rating: 1,
      custom: (altacv: (rating: 4.5)),
    ),
    // Deprecated rating (2.5) still beats fluency ("Native" → 5).
    (language: "Italian", fluency: "Native", rating: 2.5),
  ),
  awards: (
    (
      title: "Best Paper Award",
      url: "https://example.com/deprecated",
      custom: (altacv: (url: "https://example.com/custom")),
    ),
  ),
))

#pagebreak()

#alta((
  basics: basics + (custom: (othertool: (theme: "dark"))),
  custom: (
    othertool: (focusAreas: ([Another tool's data — not rendered.],)),
    altacv: (focusAreas: ([Only altacv's namespace is read.],)),
  ),
  languages: (
    (
      language: "English",
      fluency: "Native",
      custom: (othertool: (rating: 1), altacv: (:)),
    ),
  ),
  awards: (
    (
      title: "Hackathon Winner",
      custom: (othertool: (url: "https://example.com/not-linked")),
    ),
  ),
))
