// `preferences.mapsProvider` accepts a URL template string (with a
// `{q}` placeholder for the URL-encoded location) or `none` to
// suppress the link entirely. Built-in templates are exported as
// `maps-providers.{google,apple,bing,duckduckgo,osm}`; any other URL
// template works too — no code change needed to support a new
// provider. One document per built-in, plus three covering the rest
// of the API surface:
//
//   1–5. Each built-in (google default, apple, bing, duckduckgo, osm).
//   6.   `none` — icon + plain text, no link.
//   7.   Custom (non-built-in) URL template — Yandex Maps,
//        demonstrates that the template doesn't have to come from
//        `maps-providers`.
//
// No reference images: the documents differ only in their links, so
// `assert-links` checks each document's instead.

#import "/internal/data/defaults.typ": maps-providers
#import "/lib.typ": alta
#import "/tests/visual/_links.typ": assert-links

#alta(
  (
    basics: (
      name: "Default User",
      label: "Implicit Google",
      email: "default@example.com",
      location: "Berlin, Germany",
    ),
  ),
)
#assert-links((
  "mailto:default@example.com",
  "https://www.google.com/maps?q=Berlin%2C%20Germany",
))

#pagebreak()

#alta(
  (
    basics: (
      name: "Apple Maps User",
      label: "Built-in: maps-providers.apple",
      email: "apple@example.com",
      location: "Cupertino, California",
    ),
  ),
  preferences: (mapsProvider: maps-providers.apple),
)
#assert-links((
  "mailto:apple@example.com",
  "https://maps.apple.com/?q=Cupertino%2C%20California",
))

#pagebreak()

#alta(
  (
    basics: (
      name: "Bing Maps User",
      label: "Built-in: maps-providers.bing",
      email: "bing@example.com",
      location: "Redmond, Washington",
    ),
  ),
  preferences: (mapsProvider: maps-providers.bing),
)
#assert-links((
  "mailto:bing@example.com",
  "https://www.bing.com/maps?q=Redmond%2C%20Washington",
))

#pagebreak()

#alta(
  (
    basics: (
      name: "DuckDuckGo Maps User",
      label: "Built-in: maps-providers.duckduckgo",
      email: "ddg@example.com",
      location: "Paoli, Pennsylvania",
    ),
  ),
  preferences: (mapsProvider: maps-providers.duckduckgo),
)
#assert-links((
  "mailto:ddg@example.com",
  "https://duckduckgo.com/?q=Paoli%2C%20Pennsylvania&iaxm=maps",
))

#pagebreak()

#alta(
  (
    basics: (
      name: "OSM User",
      label: "Built-in: maps-providers.osm",
      email: "osm@example.com",
      location: "Dublin, Ireland",
    ),
  ),
  preferences: (mapsProvider: maps-providers.osm),
)
#assert-links((
  "mailto:osm@example.com",
  "https://www.openstreetmap.org/search?query=Dublin%2C%20Ireland",
))

#pagebreak()

#alta(
  (
    basics: (
      name: "No Link User",
      label: "Plain text location — mapsProvider: none",
      email: "nolink@example.com",
      location: "Zürich, Switzerland",
    ),
  ),
  preferences: (mapsProvider: none),
)
#assert-links(("mailto:nolink@example.com",))

#pagebreak()

#alta(
  (
    basics: (
      name: "Custom Provider User",
      label: "Arbitrary URL template — no code change",
      email: "custom@example.com",
      location: "Yerevan, Armenia",
    ),
  ),
  preferences: (mapsProvider: "https://yandex.com/maps/?text={q}"),
)
#assert-links((
  "mailto:custom@example.com",
  "https://yandex.com/maps/?text=Yerevan%2C%20Armenia",
))
