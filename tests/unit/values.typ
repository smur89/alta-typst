// Unit checks for the util helpers in internal/util/values.typ and
// fields.typ. The location formatter and grouping by `type` built on
// them are `adapter.location-parts`' and `adapter.group-by-type`'s, in
// adapter.typ.

#import "/internal/util/fields.typ": _field
#import "/internal/util/values.typ": (
  _deep-merge, _fill-template, _group-by, _join-present, _map-at, _present,
  _present-str,
)

// _present / _present-str: the three absent forms, and strings only.
#for v in (none, "", []) { assert(not _present(v), message: repr(v)) }
#for v in ("x", [x], 0) { assert(_present(v), message: repr(v)) }
#assert(_present-str("x"))
#for v in ([x], "", 3) { assert(not _present-str(v), message: repr(v)) }

// _field: present values pass through; every absent form is `none`.
#assert.eq(_field((a: "x"), "a"), "x")
#for e in ((:), (a: none), (a: ""), (a: [])) {
  assert.eq(_field(e, "a"), none, message: repr(e))
}

// _join-present: `none` parts drop out with their separator; nothing
// left is `none`, not an empty string.
#assert.eq(_join-present(("a", none, "b"), ", "), "a, b")
#assert.eq(_join-present((none, none), ", "), none)

// _fill-template: one pass, so a substituted value is never expanded.
#assert.eq(
  _fill-template("Page {current} / {total}", (current: "2", total: "3")),
  "Page 2 / 3",
)
#assert.eq(_fill-template("{name} — CV", (name: "{total}")), "{total} — CV")

// _deep-merge: nested dictionaries merge key by key; anything else
// replaces.
#assert.eq(
  _deep-merge((a: (x: 1, y: 2), b: 3), (a: (y: 4), c: 5)),
  (a: (x: 1, y: 4), b: 3, c: 5),
)
#assert.eq(_deep-merge((a: (x: 1)), (a: 2)), (a: 2))
#assert.eq(_deep-merge((a: 1), (a: (x: 1))), (a: (x: 1)))
#assert.eq(_deep-merge((a: 1), (:)), (a: 1))

// _map-at: `f` on the dictionary at `key` (or `default`);
// any other value, or a table that isn't a dictionary, passes through.
#assert.eq(_map-at((a: (x: 1)), "a", d => d + (y: 2)), (a: (x: 1, y: 2)))
#assert.eq(_map-at((a: 1), "a", d => d + (y: 2)), (a: 1))
#assert.eq(_map-at((:), "a", d => d + (y: 2)), (:))
#assert.eq(_map-at((:), "a", default: (:), d => d + (y: 2)), (a: (y: 2)))
#assert.eq(_map-at("x", "a", d => d), "x")

// _group-by: first-occurrence key order, items keep their order.
#assert.eq(
  _group-by((1, 2, 3, 4, 5), n => if calc.odd(n) { "odd" } else { "even" }),
  (odd: (1, 3, 5), even: (2, 4)),
)
