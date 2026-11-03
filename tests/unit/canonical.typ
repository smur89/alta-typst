// Unit checks for how `publicationIcons` resolves, through
// `_merge_options`, the sequence `alta()` runs.

#import "/internal/options.typ": _merge_options

#let icons(prefs: (:), labels: (:)) = {
  _merge_options(
    (publicationIcons: labels),
    (publicationIcons: prefs),
  )
    .preferences
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
