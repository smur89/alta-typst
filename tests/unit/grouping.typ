// Unit checks for grouping: `_group_by` (internal/util/values.typ) and
// projects' `_group_by_type` (sections/projects.typ).

#import "/internal/util/values.typ": _group_by
#import "/sections/projects.typ": _group_by_type

// _group_by: first-occurrence key order, items keep their order.
#assert.eq(
  _group_by((1, 2, 3, 4, 5), n => if calc.odd(n) { "odd" } else { "even" }),
  (odd: (1, 3, 5), even: (2, 4)),
)
// _group_by_type: a missing, empty or non-string `type` pools under
// the fallback.
#assert.eq(
  _group_by_type(
    ((type: "OSS"), (:), (type: ""), (type: 3), (type: "OSS")),
    "Other",
  )
    .pairs()
    .map(((k, v)) => (k, v.len())),
  (("OSS", 2), ("Other", 3)),
)
