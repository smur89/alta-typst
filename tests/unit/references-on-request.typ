// `references-available-on-request` draws the on-request line under
// the references' heading when no reference renders, and adds nothing
// to a quote: `alta()` in the template, then the mapping's `resume()`,
// which draws the same.

#import "/lib.typ": alta, altacv
#import "/adapter/json-resume.typ": resume
#import "_count.typ": count

#show: altacv

#let (lines, count-line) = count("References available upon request.")
#show "References available upon request.": count-line
// The references' headings and on-request lines drawn so far.
#let drawn() = (
  query(heading.where(body: [References]).before(here())).len(),
  lines.get(),
)

#let prefs = (references-available-on-request: true)
// A reference with a name alone has nothing to draw.
#let unquoted = (basics: (name: "Jane Doe"), references: ((name: "R"),))
#let quoted = (
  basics: (name: "Jane Doe"),
  references: ((name: "R", reference: "Great."),),
)

#alta(unquoted, preferences: prefs)
#context assert.eq(drawn(), (1, 1))
#resume(unquoted, preferences: prefs)
#context assert.eq(drawn(), (2, 2))

#pagebreak()
#alta(quoted, preferences: prefs)
#context assert.eq(drawn(), (3, 2))
#resume(quoted, preferences: prefs)
#context assert.eq(drawn(), (4, 2))

// Off by default.
#pagebreak()
#alta(unquoted)
#resume(unquoted)
#context assert.eq(drawn(), (4, 2))
