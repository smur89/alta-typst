// Unit checks for the referee attribution line in
// sections/references.typ, of an entry as `_canonical-cv` leaves it.

#import "/lib.typ": adapter
#import "/internal/data/canonical.typ": _canonical-cv
#import "/internal/design/theme.typ": _default-theme
#import "/internal/primitives.typ": _join-facts
#import "/sections/references.typ": _attribution

// Joined as `_fact-line` would, with the default separators.
#let attribution(entry, format: "long") = _join-facts(
  _default-theme.separator,
  .._attribution(
    _canonical-cv(
      (basics: (name: "A"), references: (entry,)),
      adapter.preferences(),
    )
      .references
      .first(),
    adapter.format-date.with(format: format),
  ),
)

#assert.eq(
  attribution((
    relationship: "Manager",
    organization: "Pied Piper",
    date: "2024",
  )),
  "Manager, Pied Piper · 2024",
)
#assert.eq(attribution((organization: "Pied Piper")), "Pied Piper")
#assert.eq(attribution((date: "2024-03")), "Mar 2024")
#assert.eq(attribution((date: "2024-03"), format: "short"), "03/2024")
#assert.eq(
  attribution((relationship: "", organization: 42, date: "")),
  none,
)
#assert.eq(attribution((:)), none)
// A non-string date is skipped like the other parts.
#assert.eq(attribution((relationship: "Peer", date: 2024)), "Peer")
