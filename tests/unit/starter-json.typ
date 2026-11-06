// The starter's two forms, `cv.typ`'s dict and `resume.json`, are
// one CV: `alta()` of the dict (its photo removed: JSON has none)
// and `alta-from-json` of the file render the same text, with its
// parts at the same places, so an edit to one without the other fails
// here.

#import "/.template-src.typ": cv, preferences
#import "/lib.typ": alta, alta-from-json, altacv

#show: altacv
// Every run of text the CV renders, wherever it sits: in a paragraph,
// a list, a pill or a line of facts.
#show text: it => [#metadata(it.text)<starter-text>#it]

#[#metadata("dict")<starter-form>]
#alta(cv + (basics: cv.basics + (image: none)), preferences: preferences)
#pagebreak()
#[#metadata("json")<starter-form>]
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
    "headline",
    "contact",
    "objective",
    "summary",
    "org",
    "date",
    "location",
    "facts",
    "keywords",
    "pill",
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
  // Each part's link target and place, page-relative, in one form, to
  // a hundredth of a point: the dict's text across lines is more runs
  // than the JSON's one string, and lands a rounding error away.
  let places(from, to) = parts.map(part => query(part)
    .filter(within(from, to))
    .map(it => {
      let pos = it.location().position()
      let pt(l) = calc.round(l.pt(), digits: 2)
      (it.at("dest", default: none), pt(pos.x), pt(pos.y), pos.page - from)
    }))

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
    assert.eq(x, y, message: repr(part) + " differs")
  }
}
