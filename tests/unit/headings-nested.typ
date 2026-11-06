// A scoped template inside another (`tests/template-scopes.typ`)
// renders the name, section, group and entry titles at the inner
// theme's sizes, as that template alone does: the outer template's
// `em` sizes don't multiply the inner one's (`_level-headings`). A
// `set text(..)` after the innermost template still scales them.

#import "/lib.typ": alta, altacv, themes

#let cv = (
  basics: (name: "Jane Doe"),
  work: ((name: "Acme", position: "Engineer"),),
  // Typed, so grouped: a group title, and entries one level below it.
  projects: ((name: "Hyperion", type: "App"), (name: "Quill", type: "Lib")),
)
#let parts = ("name", "section-title", "group-title", "entry-title")

// The sizes each part renders at under `templates`, outermost first,
// and `rule` after the innermost, recorded under `key`.
#let sizes = state("nested-heading-sizes", (:))
#let probe(key, templates, rule: it => it) = {
  let record(part, it) = {
    box(context {
      let size = text.size.to-absolute()
      sizes.update(all => {
        let seen = all.at(key, default: (:))
        all + ((key): seen + ((part): seen.at(part, default: ()) + (size,)))
      })
    })
    it
  }
  let doc = parts.fold(alta(cv), (body, part) => {
    show label("alta-" + part): record.with(part)
    body
  })
  templates
    .rev()
    .fold(rule(doc), (body, theme) => altacv(
      theme: theme,
      body,
    ))
}

// Every type ratio off its default and off Typst's own.
#let scaled = (
  type: (
    display: (size: 3),
    headline: (size: 1.2),
    title: (size: 1.1),
  ),
)
#let cases = (
  default: (themes.teal, themes.teal),
  into-scaled: (themes.teal, scaled),
  out-of-scaled: (scaled, themes.teal),
  three-deep: (scaled, themes.navy, scaled),
)
#for (key, templates) in cases {
  probe(key + "-alone", (templates.last(),))
  probe(key, templates)
}
#let body-11(it) = {
  set text(11pt)
  it
}
#probe("body-11-alone", (scaled,), rule: body-11)
#probe("body-11", (themes.teal, scaled), rule: body-11)

#context {
  let all = sizes.final()
  for key in cases.keys() + ("body-11",) {
    assert.eq(all.at(key).keys().sorted(), parts.sorted(), message: key)
    assert.eq(all.at(key), all.at(key + "-alone"), message: key)
  }
  // The scaled theme's own sizes, from the 10pt body, and from an
  // 11pt one: a work entry (level 2), then a group's (level 3).
  let expected(body) = (
    name: (3 * body,),
    section-title: (1.2 * body,) * 2,
    group-title: (1.1 * body,) * 2,
    entry-title: (1.1 * body,) * 3,
  )
  assert.eq(all.at("into-scaled"), expected(10pt))
  assert.eq(all.at("body-11"), expected(11pt))
}
