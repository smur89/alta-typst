// Unit checks for grouping: `_group-by` (internal/util/values.typ) and
// `_type-groups` (internal/data/cv.typ), which the standalone projects
// and publications and the public `adapter.group-by-type` share.

#import "/internal/util/values.typ": _group-by
#import "/internal/data/cv.typ": _type-groups

// _group-by: first-occurrence key order, items keep their order.
#assert.eq(
  _group-by((1, 2, 3, 4, 5), n => if calc.odd(n) { "odd" } else { "even" }),
  (odd: (1, 3, 5), even: (2, 4)),
)

#let sizes(groups) = groups.map(((k, v)) => (k, v.len()))

// _type-groups: a missing, empty or non-string `type` is untyped, and
// pools under `untyped` with a type of that name, as projects' "Other".
#assert.eq(
  sizes(_type-groups(
    ((type: "OSS"), (:), (type: ""), (type: 3), (type: "Other")),
    untyped: "Other",
  )),
  (("OSS", 1), ("Other", 4)),
)
// Publications' codes: `key: lower` matches types ignoring case, the
// untyped among the articles, in the order each group first appears.
#assert.eq(
  sizes(_type-groups(
    ((type: "Talk"), (:), (type: " talk "), (type: "Article")),
    key: lower,
    untyped: "article",
  )),
  (("talk", 2), ("article", 2)),
)
// The untyped under `none` by default.
#assert.eq(sizes(_type-groups(((:), (type: "x")))), ((none, 1), ("x", 1)))
