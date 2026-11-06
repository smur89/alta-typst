// Unit checks for how `alta()` reads its input into the current
// shapes (internal/data/canonical.typ): the deprecated forms (#239)
// and camelCase names of the preferences and labels, read through
// `adapter.preferences` and `adapter.labels` where they have one, and
// the CV itself (`_canonical-cv`): dates, the leniently read fields,
// and JSON Resume's camelCase fields (`_kebab-fields`).

#import "/lib.typ": adapter
#import "/internal/data/options.typ": _merge-options
#import "/internal/data/canonical.typ": _canonical-cv
#import "/internal/data/read.typ": _kebab-fields

// `publication-icons`: the preference, and the deprecated label of
// that name, which `adapter.preferences` doesn't take.
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

// #239: the string `page-footer: "auto"` reads as `auto`: standalone
// `alta()`'s preference, so not one `adapter.preferences` takes.
#assert.eq(
  _merge-options((:), (page-footer: "auto")).prefs.page-footer,
  auto,
)

// Alignments: Typst's own, or the deprecated strings (#239) read as
// them. `"center"` takes its side from `image-stack-order`.
#let prefs(preferences) = adapter.preferences(overrides: preferences)
#assert.eq(prefs((:)).photo-position, right)
#assert.eq(prefs((photo-position: top)).photo-position, top)
#assert.eq(prefs((photo-position: "left")).photo-position, left)
#assert.eq(prefs((photo-position: "center")).photo-position, top)
#assert.eq(
  prefs((photo-position: "center", image-stack-order: "below")).photo-position,
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

// The fields 1.8.0 read leniently (`_lenient-fields`) keep only what
// their readers draw, so those readers needn't check types again.
#let pub = _canonical-cv(
  (
    basics: (name: "A"),
    publications: (
      (
        authors: ("A. Smith", 3),
        identifiers: (doi: "10.1/x", pmid: 7),
        volume: 4,
      ),
      (authors: "A. Smith", identifiers: "10.1/x"),
    ),
  ),
  prefs((:)),
).publications
#assert.eq(
  pub.first(),
  (authors: ("A. Smith",), identifiers: (doi: "10.1/x")),
)
#assert.eq(pub.last(), (authors: (), identifiers: (:)))

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
#assert.eq(prefs((columnRatio: 0.5)).column-ratio, 0.5)
// 1.8.0's `imagePosition` and `imageSize` read as the photo's
// renamed preferences, the strings as alignments; the never-shipped
// kebab `image-*` spellings are unknown.
#assert.eq(
  prefs((imagePosition: "center", imageStackOrder: "below")).photo-position,
  bottom,
)
#assert.eq(prefs((imageSize: 8em)).photo-size, 8em)
#assert.eq(
  prefs((leftColumnSections: ("focusAreas",))).left-column-sections,
  ("focus-areas",),
)
#context assert.eq(
  adapter.labels(overrides: (pageNumber: "P {current}")).page-number,
  "P {current}",
)
#context assert.eq(
  adapter.labels(overrides: (focusAreas: "Focus")).focus-areas,
  "Focus",
)

// JSON Resume's camelCase fields read as kebab-case for rendering, at
// any depth (#390); keys that are data (`identifiers` schemes, other
// `custom` namespaces) keep their spelling.
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
