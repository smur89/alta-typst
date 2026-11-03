// Unit checks for `_canonical_preferences` in internal/canonical.typ,
// through the merge `alta()` runs it ahead of.

#import "/internal/canonical.typ": _canonical_labels, _canonical_preferences
#import "/internal/layout.typ": _default_preferences
#import "/internal/validation.typ": _strict_merge

#let icons(prefs: (:), labels: (:)) = {
  _strict_merge(
    _default_preferences,
    _canonical_preferences(
      (publicationIcons: prefs),
      _canonical_labels((publicationIcons: labels)),
    ),
    "preferences",
    tables: ("publicationIcons",),
  ).publicationIcons
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

// With no `publicationIcons` set, the free-text icons are still
// seeded beneath the merge.
#assert.eq(
  _canonical_preferences((accent: red), (:)).publicationIcons,
  _canonical_preferences((publicationIcons: (:)), (:)).publicationIcons,
)
#assert.eq(
  _canonical_preferences((:), (:)).publicationIcons.presentations,
  "microphone",
)
