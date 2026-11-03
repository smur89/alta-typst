// Unit checks for internal/primitives.typ.

#import "/internal/primitives.typ": _fact-line, _link-if, _portrait

// _fact-line: parts joined within a group, groups joined after; absent
// parts and emptied groups drop out, and nothing left is `none`.
#assert.eq(
  _fact-line(("Manager", "Pied Piper"), ("Mar 2024",)),
  "Manager, Pied Piper · Mar 2024",
)
#assert.eq(_fact-line((none, "Pied Piper"), (none,)), "Pied Piper")
#assert.eq(_fact-line((none,), ("2024",)), "2024")
#assert.eq(_fact-line((none, none), (none,)), none)

// _portrait: a bare string path resolves from `internal/`, where
// `image()` is called, so this asset path breaks if `_portrait` moves.
#_portrait("../assets/avatar-placeholder.svg", 1cm, "Jane")

// _link-if: linked only when the destination is present.
#assert.eq(_link-if(none, "x"), "x")
#assert.eq(_link-if("", "x"), "x")
#assert.eq(_link-if("https://a.b", "x").func(), link)
