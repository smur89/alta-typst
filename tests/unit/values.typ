// Unit checks for internal/util/values.typ's `_deep-merge` and
// `_map-at`.

#import "/internal/util/values.typ": _deep-merge, _map-at

// Nested dictionaries merge key by key; anything else replaces.
#assert.eq(
  _deep-merge((a: (x: 1, y: 2), b: 3), (a: (y: 4), c: 5)),
  (a: (x: 1, y: 4), b: 3, c: 5),
)
#assert.eq(_deep-merge((a: (x: 1)), (a: 2)), (a: 2))
#assert.eq(_deep-merge((a: 1), (a: (x: 1))), (a: (x: 1)))
#assert.eq(_deep-merge((a: 1), (:)), (a: 1))

// _map-at: `f` on the value of its `kind` at `key` (or `default`);
// any other value, or a table that isn't a dictionary, passes through.
#assert.eq(_map-at((a: (x: 1)), "a", d => d + (y: 2)), (a: (x: 1, y: 2)))
#assert.eq(_map-at((a: 1), "a", d => d + (y: 2)), (a: 1))
#assert.eq(_map-at((:), "a", d => d + (y: 2)), (:))
#assert.eq(_map-at((:), "a", default: (:), d => d + (y: 2)), (a: (y: 2)))
#assert.eq(_map-at((a: (1,)), "a", kind: array, v => v.rev()), (a: (1,)))
#assert.eq(_map-at("x", "a", d => d), "x")
