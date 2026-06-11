// preferences.mapsProvider exercises each of the supported provider
// keys. Three blocks are rendered with different providers so the
// fixture covers the OSM URL template and the "none" (no-link) branch
// in addition to the default Google. Each `#alta(...)` produces its
// own document; the fixture compiles cleanly if all three render.

#import "../lib.typ": alta

#alta(
  (basics: (
    name: "OSM User",
    label: "OpenStreetMap",
    email: "osm@example.com",
    location: "Dublin, Ireland",
  )),
  preferences: (mapsProvider: "osm"),
)

#pagebreak()

#alta(
  (basics: (
    name: "No Link User",
    label: "Plain text location",
    email: "nolink@example.com",
    location: "Zürich, Switzerland",
  )),
  preferences: (mapsProvider: "none"),
)

#pagebreak()

#alta(
  (basics: (
    name: "Default User",
    label: "Implicit Google",
    email: "default@example.com",
    location: "Berlin, Germany",
  )),
)
