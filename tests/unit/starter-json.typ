// The starter's two forms, `cv.typ`'s dict and `resume.json`, are
// one CV: `alta()` of the dict (its photo removed: JSON has none)
// and `alta-from-json` of the file render the same text, with its
// parts at the same places, so an edit to one without the other fails
// here.

#import "/.template-src.typ": cv, preferences
#import "/lib.typ": alta, alta-from-json, altacv
#import "/tests/unit/_plain.typ": plain

#show: altacv
// Every run of text the CV renders, wherever it sits: in a paragraph,
// a list, a tag or a line of facts.
#show text: it => [#metadata(it.text)<starter-text>#it]

#metadata("dict")<starter-form>
#alta(cv + (basics: cv.basics + (image: none)), preferences: preferences)
#pagebreak()
#metadata("json")<starter-form>
#alta-from-json(path("/template/resume.json"), preferences: preferences)

// Where the CV's parts sit: its headings (sections, groups and entry
// titles), paragraphs, lists and links, and the header's and each
// entry's parts, down to the rating dots.
#let parts = (
  heading,
  par,
  list,
  link,
  ..(
    "name",
    "tagline",
    "contact",
    "objective",
    "summary",
    "org",
    "date",
    "location",
    "facts",
    "keywords",
    "tag",
    "rating-label",
    "rating-full",
    "rating-empty",
  ).map(name => label("alta-" + name)),
)

#context {
  let (dict, json) = query(<starter-form>).map(m => m.location().page())
  let within(from, to) = it => {
    let p = it.location().page()
    p >= from and p < to
  }
  // One form's words, in order. Whitespace is collapsed: a `[..]`
  // across lines breaks its text where the JSON string runs on.
  let words(from, to) = query(<starter-text>)
    .filter(within(from, to))
    .map(m => m.value)
    .join(" ")
    .split(regex("\s+"))
    .filter(w => w != "")
  // Each part's link target and place, page-relative, in one form.
  let places(from, to) = parts.map(part => query(part)
    .filter(within(from, to))
    .map(it => {
      let pos = it.location().position()
      (dest: it.at("dest", default: none), pos: pos, page: pos.page - from)
    }))
  // The same part in either form: the same target, on the same page, at
  // the same place within a twentieth of a point, as the dict's text
  // across lines is more runs than the JSON's one string and can land
  // a float's error away.
  let same(x, y) = (
    x.dest == y.dest
      and x.page == y.page
      and calc.abs(x.pos.x - y.pos.x) < 0.05pt
      and calc.abs(x.pos.y - y.pos.y) < 0.05pt
  )

  let (a, b) = (words(dict, json), words(json, calc.inf))
  let at = a.zip(b).position(((x, y)) => x != y)
  let at = if at == none { calc.min(a.len(), b.len()) } else { at }
  let from-at(ws) = ws.slice(at, calc.min(at + 8, ws.len())).join(" ")
  assert(
    a == b,
    message: "the text differs at word "
      + str(at)
      + ": "
      + repr((a, b).map(from-at)),
  )

  let (a, b) = (places(dict, json), places(json, calc.inf))
  // Every part is on the page, so none compares empty against empty.
  for (part, found) in parts.zip(a) {
    assert(found.len() > 0, message: "no " + repr(part) + " in the CV")
  }
  for (part, x, y) in parts.zip(a, b) {
    assert(
      x.len() == y.len() and x.zip(y).all(((x, y)) => same(x, y)),
      message: repr(part) + " differs",
    )
  }
}

// The PDF metadata each form would set (title, author, description,
// keywords): the document keeps only the first, so compare both forms'
// here. The dict's summary is content where the JSON's is a string,
// so the description compares as words.
#context {
  let words(it) = plain(it).split().join(" ")
  let (dict, json) = query(<alta-internal-document>).map(m => {
    let info = m.value
    info + (description: words(info.description))
  })
  assert.eq(dict, json, message: "the PDF metadata differs")
}
