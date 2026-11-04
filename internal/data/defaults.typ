// The defaults the caller's labels and preferences merge over: the
// labels, kept in `labels-en.toml` so translators edit a plain resource
// file rather than Typst source, and the preferences, with the
// `maps-providers` presets for `mapsProvider`.

#import "../design/icon-set.typ": _publication-icons
#import "../design/presets.typ": palettes
#import "sections.typ": _keys-for-column

#let _default-labels = toml("labels-en.toml")

// `{q}` becomes the URL-encoded `basics.location`.
#let maps-providers = (
  google: "https://www.google.com/maps?q={q}",
  apple: "https://maps.apple.com/?q={q}",
  bing: "https://www.bing.com/maps?q={q}",
  duckduckgo: "https://duckduckgo.com/?q={q}&iaxm=maps",
  osm: "https://www.openstreetmap.org/search?query={q}",
)

// Documented in the README's preferences tables and grouped as there,
// which is also the order the "Supported:" list of an unknown-key
// panic follows. Comments here note only constraints the README
// doesn't need.
#let _default-preferences = (
  // Look.
  // Must be installed on the build host (CI installs it: apt in
  // setup-typst, apk in the pinned image).
  font: "Lato",
  bodySize: 10pt,
  accent: palettes.teal,
  publicationIcons: _publication-icons,
  projectIcons: (:),
  // Header.
  // Visual only: PDF title / author metadata keep the name as given.
  uppercaseName: true,
  headerTextAlign: "left",
  imageSize: 6em,
  imageShape: "circle",
  imagePosition: "right",
  imageStackOrder: "above",
  qrCode: none,
  // Page and layout.
  paper: "a4",
  margin: (x: 0.9cm, y: 1.5cm),
  columnRatio: 0.65,
  leftColumnSections: _keys-for-column("left"),
  rightColumnSections: _keys-for-column("right"),
  // Footer.
  pageFooter: none,
  lastModifiedFooter: false,
  // Rides the `lastModifiedFooter` line; no-op without it.
  footerVersion: false,
  // Formatting and links.
  justify: false,
  dateFormat: "long",
  linkContactInfo: true,
  mapsProvider: maps-providers.google,
  maxRating: 5,
  ownerNames: (),
  // Deprecated, removed in the next major (#239). `groupCertificates`
  // and `showPronouns` are ignored (JSON Resume dropped
  // `basics.pronouns` as added by accident,
  // https://github.com/jsonresume/jsonresume.org/pull/629),
  // and `_canonical-cv` turns `referencesAvailableOnRequest` into a
  // `references[].availableOnRequest` entry.
  groupCertificates: true,
  showPronouns: false,
  referencesAvailableOnRequest: false,
)
