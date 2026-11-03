// Unit checks for the util helpers (internal/util/fields.typ,
// values.typ, location.typ) and the treatment resolver in
// internal/design/styles.typ.

#import "/internal/design/styles.typ": _treat
#import "/internal/util/fields.typ": _field
#import "/internal/util/location.typ": _format-location
#import "/internal/util/values.typ": (
  _fill-template, _join-present, _present, _present-str,
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

// _format-location: strings pass through, dicts collapse in
// city / region / countryCode order, absent values drop out.
#assert.eq(_format-location("Cork, Ireland"), "Cork, Ireland")
#assert.eq(
  _format-location((
    city: "Cork",
    region: "Munster",
    countryCode: "IE",
    address: "1 Main St",
  )),
  "Cork, Munster, IE",
)
#assert.eq(_format-location((city: "", countryCode: "IE")), "IE")
#assert.eq(_format-location((postalCode: "T12")), none)
#assert.eq(_format-location(""), none)
#assert.eq(_format-location(none), none)

// _treat: a named treatment applies its function; "none" is identity.
#assert.eq(_treat("upper", "ab"), "AB")
#assert.eq(_treat("none", "ab"), "ab")
#assert.eq(_treat("emph", "ab").func(), emph)
