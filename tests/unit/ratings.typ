// Unit checks for `_entry-rating` and `_term-rating` (data/cv.typ),
// with skill level terms. A language's fluency is
// `adapter.fluency-rating`'s, in adapter.typ.

#import "/internal/data/cv.typ": _entry-rating, _skill-levels, _term-rating

#let _skill-rating(group, max) = _entry-rating(
  group,
  "level",
  _skill-levels,
  max,
)

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

// _term-rating: the term alone; anything but a string is `none`.
#assert.eq(_term-rating("Expert", _skill-levels, 5), 5.0)
#assert.eq(_term-rating([Expert], _skill-levels, 5), none)
#assert.eq(_term-rating(none, _skill-levels, 5), none)
