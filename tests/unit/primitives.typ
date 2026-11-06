// Unit checks for internal/primitives.typ, and the public pieces it
// and internal/icons.typ export for custom layouts: `tag`,
// `styled-link`, `divider`, `icon`, and the deprecated `name` and
// `term` (#239), which still draw.

#import "/internal/design/theme.typ": _default-theme
#import "/internal/primitives.typ": (
  _fact-line, _join-facts, _joined, _link-if, _photo,
)
#import "/lib.typ": divider, icon, name, styled-link, tag, term
#import "/tests/unit/_plain.typ": plain

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

#let accent = _default-theme.colours.accent
// The text's fill and weight where `body` is drawn.
#let looks = state("looks", (:))
#let look(body) = it => {
  context {
    let seen = (text.fill, text.weight)
    looks.update(l => l + ((body): seen))
  }
  it
}

// tag: a plain tag's text is the `tag` part, a category's the
// `tag-category` part, in the category weight; the deprecated
// `label:` draws what `category:` does.
#let tags = state("tags", ())
#show <alta-tag>: it => {
  tags.update(t => t + (("tag", plain(it)),))
  it
}
#show <alta-tag-category>: it => {
  tags.update(t => t + (("category", plain(it)),))
  it
}
#show "plain": look("plain")
#show "category": look("category")
#tag("plain")
#tag("category", category: true)
#tag("by-label", label: true)
#tag("not-label", label: false)
#context assert.eq(tags.final(), (
  ("tag", "plain"),
  ("category", "category"),
  ("category", "by-label"),
  ("tag", "not-label"),
))
#context assert.eq(
  (looks.final().plain.at(1), looks.final().category.at(1)),
  (_default-theme.tag.weight, _default-theme.tag.category-weight),
)

// styled-link: the accent, in the theme's `treatment.link` (`emph`),
// linked only with a `dest`.
#let links = state("links", ())
#show link: it => {
  links.update(l => l + (it.dest,))
  it
}
#let emphs = state("emphs", 0)
#show emph: it => {
  emphs.update(n => n + 1)
  it
}
#show "Linked": look("Linked")
#show "Unlinked": look("Unlinked")
#styled-link("Linked", dest: "https://a.example")
#styled-link("Unlinked")
#context {
  assert.eq(links.final(), ("https://a.example",))
  let l = looks.final()
  assert.eq(l.Linked.at(0), accent)
  assert.eq(emphs.final(), 2)
  assert.eq(l.Unlinked.at(0), accent)
}

// name: an accent-coloured line.
#show "Pied Piper": look("Pied Piper")
#name("Pied Piper")
#context assert.eq(looks.final().at("Pied Piper").at(0), accent)

// term: a date and a location, each led by its icon; an absent side
// left out, icon included; with neither, nothing.
#assert.eq(term(none), none)
#assert.eq(term("", location: ""), none)
#let icons() = (
  query(selector(<alta-date-icon>).before(here())).len(),
  query(selector(<alta-location-icon>).before(here())).len(),
)
#term("2024", location: "Cork")
#context assert.eq(icons(), (1, 1))
#term("2025")
#context assert.eq(icons(), (2, 1))
#term(none, location: "Dublin")
#context assert.eq(icons(), (2, 2))

// divider: Typst's divider, between gaps.
#let dividers = state("dividers", 0)
#show std.divider: it => {
  dividers.update(n => n + 1)
  it
}
#divider()
#context assert.eq(dividers.final(), 1)

// icon: decorative unless `alt` is given, which it reads as.
#let alts = state("alts", ())
#show figure: it => {
  alts.update(a => a + (it.alt,))
  it
}
#icon("calendar")
#icon("github", alt: "GitHub")
#context assert.eq(alts.final(), ("GitHub",))
