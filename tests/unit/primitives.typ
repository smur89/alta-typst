// Unit checks for internal/primitives.typ.

#import "/internal/primitives.typ": _fact_line

// _fact_line: parts joined within a group, groups joined after; absent
// parts and emptied groups drop out, and nothing left is `none`.
#assert.eq(
  _fact_line(("Manager", "Pied Piper"), ("Mar 2024",)),
  "Manager, Pied Piper · Mar 2024",
)
#assert.eq(_fact_line((none, "Pied Piper"), (none,)), "Pied Piper")
#assert.eq(_fact_line((none,), ("2024",)), "2024")
#assert.eq(_fact_line((none, none), (none,)), none)
