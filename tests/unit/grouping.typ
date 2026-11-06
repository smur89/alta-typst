// Unit checks for `_group-by` (internal/util/values.typ). Grouping by
// `type` is `adapter.group-by-type`'s, in adapter.typ.

#import "/internal/util/values.typ": _group-by

// _group-by: first-occurrence key order, items keep their order.
#assert.eq(
  _group-by((1, 2, 3, 4, 5), n => if calc.odd(n) { "odd" } else { "even" }),
  (odd: (1, 3, 5), even: (2, 4)),
)
