// Unit checks for how `publicationIcons` resolves, through
// `_merge-options`, the sequence `alta()` runs.

#import "/internal/data/options.typ": _merge-options

#let icons(prefs: (:), labels: (:)) = {
  _merge-options(
    (publicationIcons: labels),
    (publicationIcons: prefs),
  )
    .prefs
    .publicationIcons
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
// them. `"center"` takes its side from `imageStackOrder`.
#import "/internal/data/canonical.typ": _canonical-cv
#let prefs(preferences) = _merge-options((:), preferences).prefs
#assert.eq(prefs((:)).imagePosition, right)
#assert.eq(prefs((imagePosition: top)).imagePosition, top)
#assert.eq(prefs((imagePosition: "left")).imagePosition, left)
#assert.eq(prefs((imagePosition: "center")).imagePosition, top)
#assert.eq(
  prefs((imagePosition: "center", imageStackOrder: "below")).imagePosition,
  bottom,
)
#assert.eq(prefs((headerTextAlign: "center")).headerTextAlign, center)
#assert.eq(prefs((headerTextAlign: right)).headerTextAlign, right)

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
#assert.eq(prefs((mapsProvider: none)).mapsProvider, none)
#assert.eq(
  prefs((headerTextAlign: "left")).mapsProvider,
  prefs((:)).mapsProvider,
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
