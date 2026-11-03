// `rating(..., max:)` sets the dot count for one call, independent of
// `preferences.maxRating` (5 here): the first row is six of six dots,
// which would panic as out of range if `max` were ignored. The second
// row uses the default, the enclosing `alta()`'s five. The rows ride
// `focusAreas`, which takes content, so they render inside the CV.

#import "../internal/components/ratings.typ": rating
#import "../lib.typ": alta

#alta(
  (
    basics: (name: "Jane Doe", email: "jane@example.com"),
    custom: (
      altacv: (
        focusAreas: (
          rating("Six of six", 6, max: 6),
          rating("Three of five", 3),
        ),
      ),
    ),
  ),
  preferences: (maxRating: 5),
)
