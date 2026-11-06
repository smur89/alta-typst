// The block arguments that let a mapping draw what `alta()` draws: an
// entry's summary, period, subtitle and keywords lead, and the header's
// contact rows.

#import "/lib.typ": adapter, altacv, contact, cv-header, entry
#import "/internal/blocks.typ": _plain

#set document(title: "Jane Doe")
#show: altacv

#let count(name) = state("count-" + name, 0)
#let counting(name) = it => {
  count(name).update(n => n + 1)
  it
}
#let summaries = state("summaries", ())
#show <alta-summary>: it => {
  summaries.update(xs => xs + (_plain(it),))
  it
}
// The theme's separators, as `alta()` joins a period and fact groups.
#show "2022 – Present": counting("open")
#show "Mar 2020 – 2021": counting("closed")
#show "2019-only": counting("end-alone")
#show <alta-date>: counting("dates")
#show "Manager, Acme · 2024": counting("subtitle")
#show "Physics · Distinction": counting("lead")
#show linebreak: counting("linebreak")

= Experience
#entry(title: "A", summary: "Led the team", date: ("2022", none))[]
#entry(title: "B", date: ("Mar 2020", "2021"))[]
// No start: the end alone; neither: nothing.
#entry(title: "C", date: (none, "2019-only"))[]
#entry(title: "D", date: (none, none))[]
#entry(
  title: "E",
  subtitle: (("Manager", "Acme"), ("2024",)),
  keywords-lead: (("Physics",), ("Distinction",)),
)[]
#metadata(none)<entries>

#context {
  let at = locate(<entries>)
  assert.eq(summaries.at(at), ("Led the team",))
  assert.eq(count("open").at(at), 1)
  assert.eq(count("closed").at(at), 1)
  assert.eq(count("end-alone").at(at), 1)
  // A, B and C: `(none, none)` draws no date.
  assert.eq(count("dates").at(at), 3)
  assert.eq(count("subtitle").at(at), 1)
  assert.eq(count("lead").at(at), 1)
}

// A `linebreak()` among the contacts starts a second row; without one,
// the contacts are one row; `basics-contacts`' records take one too.
#let before-headers = state("before-headers", 0)
#context before-headers.update(count("linebreak").get())
#cv-header(contacts: (contact("email", "j@d.ie"), contact("phone", "1")))
#metadata(none)<one-row>
#cv-header(contacts: (
  contact("email", "j@d.ie"),
  linebreak(),
  contact("github", "jane"),
))
#metadata(none)<two-rows>
#cv-header(contacts: adapter.basics-contacts((
  name: "Jane Doe",
  email: "j@d.ie",
  profiles: ((network: "GitHub", username: "jane"),),
)))
#metadata(none)<adapter-rows>
#context {
  let base = before-headers.final()
  assert.eq(count("linebreak").at(locate(<one-row>)), base)
  assert.eq(count("linebreak").at(locate(<two-rows>)), base + 1)
  assert.eq(count("linebreak").at(locate(<adapter-rows>)), base + 2)
}
