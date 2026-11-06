// `entry(location: ..)` as an array of parts, joined by the theme's
// item separator as `alta()` joins a location's; the JSON Resume
// mapping passes `adapter.location-parts(..)` so, and its locations take
// a theme's separator too.

#import "/lib.typ": altacv, entry, themes
#import "/adapter/json-resume.typ": resume

#show: altacv.with(theme: themes.teal + (separator: (items: " / ")))
#set document(title: "Jane Doe")

#let seen = state("seen", 0)
#show "Cork / IE": it => {
  seen.update(n => n + 1)
  it
}

= Experience
#entry(title: "A", location: ("Cork", "IE"))[]
#context assert.eq(seen.get(), 1)

#resume((
  basics: (name: "Jane Doe"),
  work: (
    (
      name: "Acme",
      position: "Engineer",
      location: (city: "Cork", countryCode: "IE"),
    ),
  ),
))
#context assert.eq(seen.get(), 2)
