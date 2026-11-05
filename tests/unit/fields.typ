// Unit checks for the util helpers (internal/util/fields.typ,
// values.typ) and the location formatter in internal/data/cv.typ.

#import "/internal/util/fields.typ": _field
#import "/internal/data/cv.typ": _location-parts
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

// _location-parts: strings pass through whole, dicts give their
// city / region / country-code parts in that order (the names
// rendering reads, `_kebab-fields`), absent values drop
// out.
#assert.eq(_location-parts((location: "Cork, Ireland")), ("Cork, Ireland",))
#assert.eq(
  _location-parts((
    location: (
      city: "Cork",
      region: "Munster",
      country-code: "IE",
      address: "1 Main St",
    ),
  )),
  ("Cork", "Munster", "IE"),
)
#assert.eq(_location-parts((location: (city: "", country-code: "IE"))), ("IE",))
#assert.eq(_location-parts((location: (postal-code: "T12"))), ())
#assert.eq(_location-parts((location: "")), ())
#assert.eq(_location-parts((:)), ())
