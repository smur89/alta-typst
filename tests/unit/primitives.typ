// Unit checks for internal/primitives.typ.

#import "/internal/design/theme.typ": _default-theme
#import "/internal/primitives.typ": (
  _fact-line, _join-facts, _joined, _link-if, _photo,
)

// _join-facts: parts joined within a group, groups joined after;
// absent parts and emptied groups drop out, and nothing left is `none`.
#let facts = _join-facts.with(_default-theme.separator)
#assert.eq(
  facts(("Manager", "Pied Piper"), ("Mar 2024",)),
  "Manager, Pied Piper · Mar 2024",
)
#assert.eq(facts((none, "Pied Piper"), (none,)), "Pied Piper")
#assert.eq(facts((none,), ("2024",)), "2024")
#assert.eq(facts((none, none), (none,)), none)
// _fact-line: the same, with the theme's separators read in context;
// still `none` with nothing to show.
#assert.eq(_fact-line((none, ""), (none,)), none)
#assert.ne(_fact-line((none,), ("2024",)), none)

// _photo: a bare string path resolves from `internal/`, where
// `image()` is called, so this asset path breaks if `_photo` moves.
#_photo("../assets/avatar-placeholder.svg", 1cm, "Jane")

// _link-if: linked only when the destination is present.
#assert.eq(_link-if(none, "x"), "x")
#assert.eq(_link-if("", "x"), "x")
#assert.eq(_link-if("https://a.b", "x").func(), link)

// _joined: nothing without a part to show.
#assert.eq(_joined("keywords", ("", none)), none)

// tag: the deprecated `label:` (#239) draws what `category:` does.
#import "/lib.typ": tag
#assert.eq(tag("x", label: true), tag("x", category: true))
#assert.eq(tag("x", label: false), tag("x"))
