// Unit checks for internal/text.typ, internal/location.typ and the
// grouping helpers in internal/primitives.typ.

#import "/internal/text.typ": _fill_template, _present, _present_str
#import "/internal/location.typ": _format_location
#import "/internal/primitives.typ": _group_by, _group_by_type

// _present / _present_str: the three absent forms, and strings only.
#assert(not _present(none))
#assert(not _present(""))
#assert(not _present([]))
#assert(_present("x"))
#assert(_present([x]))
#assert(_present(0))
#assert(_present_str("x"))
#assert(not _present_str([x]))
#assert(not _present_str(""))
#assert(not _present_str(3))

// _fill_template: one pass, so a substituted value is never expanded.
#assert.eq(
  _fill_template("Page {current} / {total}", (current: "2", total: "3")),
  "Page 2 / 3",
)
#assert.eq(_fill_template("{name} — CV", (name: "{total}")), "{total} — CV")

// _format_location: strings pass through, dicts collapse in
// city / region / countryCode order, absent values drop out.
#assert.eq(_format_location("Cork, Ireland", "x"), "Cork, Ireland")
#assert.eq(
  _format_location(
    (city: "Cork", region: "Munster", countryCode: "IE", address: "1 Main St"),
    "x",
  ),
  "Cork, Munster, IE",
)
#assert.eq(_format_location((city: "", countryCode: "IE"), "x"), "IE")
#assert.eq(_format_location((postalCode: "T12"), "x"), none)
#assert.eq(_format_location("", "x"), none)
#assert.eq(_format_location(none, "x"), none)

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
  ).pairs().map(((k, v)) => (k, v.len())),
  (("OSS", 2), ("Other", 3)),
)
