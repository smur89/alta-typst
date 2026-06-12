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

#import "../lib.typ": alta, maps-providers

#alta(
  (basics: (
    name: "Default User",
    label: "Implicit Google",
    email: "default@example.com",
    location: "Berlin, Germany",
  )),
)

#pagebreak()

#alta(
  (basics: (
    name: "Apple Maps User",
    label: "Built-in: maps-providers.apple",
    email: "apple@example.com",
    location: "Cupertino, California",
  )),
  preferences: (mapsProvider: maps-providers.apple),
)

#pagebreak()

#alta(
  (basics: (
    name: "Bing Maps User",
    label: "Built-in: maps-providers.bing",
    email: "bing@example.com",
    location: "Redmond, Washington",
  )),
  preferences: (mapsProvider: maps-providers.bing),
)

#pagebreak()

#alta(
  (basics: (
    name: "DuckDuckGo Maps User",
    label: "Built-in: maps-providers.duckduckgo",
    email: "ddg@example.com",
    location: "Paoli, Pennsylvania",
  )),
  preferences: (mapsProvider: maps-providers.duckduckgo),
)

#pagebreak()

#alta(
  (basics: (
    name: "OSM User",
    label: "Built-in: maps-providers.osm",
    email: "osm@example.com",
    location: "Dublin, Ireland",
  )),
  preferences: (mapsProvider: maps-providers.osm),
)

#pagebreak()

#alta(
  (basics: (
    name: "No Link User",
    label: "Plain text location — mapsProvider: none",
    email: "nolink@example.com",
    location: "Zürich, Switzerland",
  )),
  preferences: (mapsProvider: none),
)

#pagebreak()

#alta(
  (basics: (
    name: "Custom Provider User",
    label: "Arbitrary URL template — no code change",
    email: "custom@example.com",
    location: "Yerevan, Armenia",
  )),
  preferences: (mapsProvider: "https://yandex.com/maps/?text={q}"),
)
