// Unit checks for internal/util/values.typ's `_deep-merge`.

#import "/internal/util/values.typ": _deep-merge

// Nested dictionaries merge key by key; anything else replaces.
#assert.eq(
  _deep-merge((a: (x: 1, y: 2), b: 3), (a: (y: 4), c: 5)),
  (a: (x: 1, y: 4), b: 3, c: 5),
)
#assert.eq(_deep-merge((a: (x: 1)), (a: 2)), (a: 2))
#assert.eq(_deep-merge((a: 1), (a: (x: 1))), (a: (x: 1)))
#assert.eq(_deep-merge((a: 1), (:)), (a: 1))
