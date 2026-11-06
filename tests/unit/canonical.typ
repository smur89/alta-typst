// Unit checks for how `publication-icons` resolves, through
// `_merge-options`, the sequence `alta()` runs.

#import "/internal/data/options.typ": _merge-options

#let icons(prefs: (:), labels: (:)) = {
  _merge-options(
    (publication-icons: labels),
    (publication-icons: prefs),
  )
    .prefs
    .publication-icons
}

// Built-ins and the deprecated free-text icons with nothing set.
#assert.eq(icons().article, "newspaper")
#assert.eq(icons().presentations, "microphone")
#assert("patent" not in icons())

// The preference wins over the deprecated label, key by key, and both
// over the built-ins; keys are lowercased.
#let both = icons(
  prefs: (Book: "file", podcast: "microphone"),
  labels: (book: "newspaper", Thesis: "microphone"),
)
#assert.eq(both.book, "file")
#assert.eq(both.thesis, "microphone")
#assert.eq(both.podcast, "microphone")
#assert.eq(both.talk, "microphone")
#assert("Book" not in both)

// The deprecated label's icon names aren't checked, so an unused bad
// one doesn't stop a CV compiling, as before the preference existed.
#assert.eq(icons(labels: (podcast: "podium")).podcast, "podium")

// Alignments: Typst's own, or the deprecated strings (#239) read as
// them. `"center"` takes its side from `image-stack-order`.
#import "/internal/data/canonical.typ": _canonical-cv
#let prefs(preferences) = _merge-options((:), preferences).prefs
// #239: the string `page-footer: "auto"` reads as `auto`.
#assert.eq(prefs((page-footer: "auto")).page-footer, auto)
#assert.eq(prefs((:)).image-position, right)
#assert.eq(prefs((image-position: top)).image-position, top)
#assert.eq(prefs((image-position: "left")).image-position, left)
#assert.eq(prefs((image-position: "center")).image-position, top)
#assert.eq(
  prefs((image-position: "center", image-stack-order: "below")).image-position,
  bottom,
)
#assert.eq(prefs((header-text-align: "center")).header-text-align, center)
#assert.eq(prefs((header-text-align: right)).header-text-align, right)

// A `datetime` reads as its ISO date, at any depth; one with no date
// (a time) is left for the field checks to name.
#let cv = _canonical-cv(
  (
    basics: (name: "A"),
    work: ((startDate: datetime(year: 2022, month: 3, day: 1)),),
    meta: (lastModified: datetime(year: 2026, month: 6, day: 12)),
  ),
  prefs((:)),
)
#assert.eq(cv.work.first().startDate, "2022-03-01")
#assert.eq(cv.meta.lastModified, "2026-06-12")
#let time = datetime(hour: 9, minute: 0, second: 0)
#assert.eq(
  _canonical-cv((basics: (name: "A"), meta: (lastModified: time)), prefs((:)))
    .meta
    .lastModified,
  time,
)

// A deliberate `none` the alignments don't touch keeps its meaning.
#assert.eq(prefs((maps-provider: none)).maps-provider, none)
#assert.eq(
  prefs((header-text-align: "left")).maps-provider,
  prefs((:)).maps-provider,
)

// A `datetime` with a time keeps it.
#assert.eq(
  _canonical-cv(
    (
      basics: (name: "A"),
      meta: (
        lastModified: datetime(
          year: 2026,
          month: 6,
          day: 12,
          hour: 9,
          minute: 30,
          second: 0,
        ),
      ),
    ),
    prefs((:)),
  )
    .meta
    .lastModified,
  "2026-06-12T09:30:00",
)

// The camelCase names (#239) read as kebab-case: the preferences and
// the labels. Values are data, so section keys keep their spelling.
#let merged(labels: (:), preferences: (:)) = _merge-options(
  labels,
  preferences,
)
#assert.eq(merged(preferences: (columnRatio: 0.5)).prefs.column-ratio, 0.5)
#assert.eq(
  merged(preferences: (leftColumnSections: ("focusAreas",)))
    .prefs
    .left-column-sections,
  ("focus-areas",),
)
#assert.eq(
  merged(labels: (pageNumber: "P {current}")).labels.page-number,
  "P {current}",
)
#assert.eq(merged(labels: (focusAreas: "Focus")).labels.focus-areas, "Focus")

// JSON Resume's camelCase fields read as kebab-case for rendering, at
// any depth (#390); keys that are data (`identifiers` schemes, other
// `custom` namespaces) keep their spelling.
#import "/internal/data/read.typ": _kebab-fields
#assert.eq(
  _kebab-fields((
    work: ((startDate: "2020", location: (countryCode: "IE")),),
    publications: ((identifiers: (arXiv: "2101.00001")),),
    custom: (altacv: (focusAreas: ([A],)), other: (fooBar: 1)),
  )),
  (
    work: ((start-date: "2020", location: (country-code: "IE")),),
    publications: ((identifiers: (arXiv: "2101.00001")),),
    custom: (altacv: (focus-areas: ([A],)), other: (fooBar: 1)),
  ),
)
