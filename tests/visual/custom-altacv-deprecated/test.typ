// altacv's non-spec fields in their deprecated top-level forms
// (`focusAreas`, `languages[].rating`, `awards[].url`) render exactly
// as their `custom.altacv` forms do (ref.typ). A
// render can't show the award's link, so `assert-links` checks it.

#import "/lib.typ": alta
#import "/tests/visual/_links.typ": assert-links
#import "/tests/fixtures/custom-altacv.typ": basics

#alta((
  basics: basics,
  focusAreas: (
    [Distributed systems and event-driven architecture.],
    [Developer experience and tooling.],
  ),
  languages: (
    (language: "English", fluency: "Native", rating: 5),
    (language: "German", fluency: "Fluent", rating: 3.5),
    (language: "French", rating: 2),
  ),
  awards: (
    (
      title: "Best Paper Award",
      awarder: "ScalaConf",
      url: "https://example.com/best-paper",
    ),
  ),
))

#assert-links(("mailto:jane@example.com", "https://example.com/best-paper"))
