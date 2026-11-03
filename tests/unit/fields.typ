// Unit checks for internal/util/fields.typ, internal/util/location.typ
// and the treatment resolver in internal/design/styles.typ.

#import "/internal/design/styles.typ": _treat
#import "/internal/util/fields.typ": (
  _field, _fill_template, _join_present, _present, _present_str,
)
#import "/internal/util/location.typ": _format_location

// _present / _present_str: the three absent forms, and strings only.
#for v in (none, "", []) { assert(not _present(v), message: repr(v)) }
#for v in ("x", [x], 0) { assert(_present(v), message: repr(v)) }
#assert(_present_str("x"))
#for v in ([x], "", 3) { assert(not _present_str(v), message: repr(v)) }

// _field: present values pass through; every absent form is `none`.
#assert.eq(_field((a: "x"), "a"), "x")
#for e in ((:), (a: none), (a: ""), (a: [])) {
  assert.eq(_field(e, "a"), none, message: repr(e))
}

// _join_present: `none` parts drop out with their separator; nothing
// left is `none`, not an empty string.
#assert.eq(_join_present(("a", none, "b"), ", "), "a, b")
#assert.eq(_join_present((none, none), ", "), none)

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

// _treat: a named treatment applies its function; "none" is identity.
#assert.eq(_treat("upper", "ab"), "AB")
#assert.eq(_treat("none", "ab"), "ab")
#assert.eq(_treat("emph", "ab").func(), emph)
