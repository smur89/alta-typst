// Unit checks for fluency resolution in sections/languages.typ.

#import "/sections/languages.typ": _resolve-rating

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
