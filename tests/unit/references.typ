// Unit checks for the referee attribution line in
// sections/references.typ.

#import "/internal/data/defaults.typ": _default-labels
#import "/internal/design/theme.typ": _default-theme
#import "/internal/primitives.typ": _join-facts
#import "/internal/util/dates.typ": _format-date
#import "/sections/references.typ": _attribution

// Joined as `_fact-line` would, with the default separators.
#let attribution(entry, format: "long") = _join-facts(
  _default-theme.separator,
  .._attribution(
    entry,
    v => _format-date(v, format, _default-labels.months),
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
