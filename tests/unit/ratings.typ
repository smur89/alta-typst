// Unit checks for `_term-rating` (data/cv.typ), with language fluency
// and skill level terms.

#import "/internal/data/cv.typ": _fluency-terms, _skill-levels, _term-rating

#let _resolve-rating(entry, max) = _term-rating(
  entry,
  "fluency",
  _fluency-terms,
  max,
)
#let _skill-rating(group, max) = _term-rating(
  group,
  "level",
  _skill-levels,
  max,
)

// LinkedIn fluency scales to the dot count, rounded to the half
// (Full Professional is 0.8: 3.2 of 4 rounds to 3, 4.8 of 6 to 5).
#assert.eq(_resolve-rating((fluency: "Native"), 5), 5.0)
#assert.eq(_resolve-rating((fluency: "Professional Working"), 5), 3.0)
#assert.eq(_resolve-rating((fluency: "Full Professional"), 4), 3.0)
#assert.eq(_resolve-rating((fluency: "Full Professional"), 6), 5.0)
#assert.eq(_resolve-rating((fluency: "Elementary"), 6), 1.0)
// Case and surrounding spaces don't matter.
#assert.eq(_resolve-rating((fluency: " native "), 5), 5.0)
// A numeric rating wins over fluency and is used as given.
#assert.eq(
  _resolve-rating((fluency: "Native", custom: (altacv: (rating: 2.5))), 5),
  2.5,
)
// Unrecognised fluency means label-only.
#assert.eq(_resolve-rating((fluency: "Fluent"), 5), none)

// _skill-rating: `custom.altacv.rating` wins, known levels scale to
// `max` (case-insensitive, trimmed) and round to the half, and an
// unknown or missing level is `none`.
#assert.eq(_skill-rating((level: "Master"), 5), 5.0)
#assert.eq(_skill-rating((level: " intermediate "), 5), 3.0)
#assert.eq(_skill-rating((level: "Advanced"), 6), 5.0)
#assert.eq(_skill-rating((level: "Novice"), 4), 1.0)
#assert.eq(
  _skill-rating((level: "Master", custom: (altacv: (rating: 2.5))), 5),
  2.5,
)
#assert.eq(_skill-rating((level: "Comfortable"), 5), none)
#assert.eq(_skill-rating((:), 5), none)
