// Default labels, kept in `labels-en.toml` so translators edit a plain
// resource file rather than Typst source.

#let _default_labels = toml("labels-en.toml")

// `{q}` becomes the URL-encoded `basics.location`.
#let maps-providers = (
  google: "https://www.google.com/maps?q={q}",
  apple: "https://maps.apple.com/?q={q}",
  bing: "https://www.bing.com/maps?q={q}",
  duckduckgo: "https://duckduckgo.com/?q={q}&iaxm=maps",
  osm: "https://www.openstreetmap.org/search?query={q}",
)
