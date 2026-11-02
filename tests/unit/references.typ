// Unit checks for the referee attribution line in
// sections/references.typ.

#import "/sections/references.typ": _attribution
#import "/internal/defaults.typ": _default_labels

#let attribution(entry, format: "long") = _attribution(
  entry,
  (dateFormat: format),
  _default_labels,
)

#assert.eq(
  attribution((relationship: "Manager", organization: "Pied Piper", date: "2024")),
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
