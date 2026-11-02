// Unit checks for fluency resolution in internal/ratings.typ.

#import "/internal/ratings.typ": _resolve_rating, _round_half

#assert.eq(_round_half(2.24), 2.0)
#assert.eq(_round_half(2.26), 2.5)

// LinkedIn fluency scales to the dot count, rounded to the half.
#assert.eq(_resolve_rating((fluency: "Native"), 5), 5.0)
#assert.eq(_resolve_rating((fluency: "Professional Working"), 5), 3.0)
#assert.eq(_resolve_rating((fluency: "Full Professional"), 4), 3.0)
#assert.eq(_resolve_rating((fluency: "Elementary"), 6), 1.0)
// Case and surrounding spaces don't matter.
#assert.eq(_resolve_rating((fluency: " native "), 5), 5.0)
// A numeric rating wins over fluency and is used as given.
#assert.eq(
  _resolve_rating((fluency: "Native", custom: (altacv: (rating: 2.5))), 5),
  2.5,
)
// Unrecognised fluency means label-only.
#assert.eq(_resolve_rating((fluency: "Fluent"), 5), none)
