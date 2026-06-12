// preferences.qrCode renders a small QR matrix in the header on the
// side opposite the portrait. Documents exercise:
//   1. `"url"` form — encodes basics.url, no portrait. QR lands on the
//      side opposite imagePosition (default "right" → QR on the left).
//   2. Explicit URL string — distinct from any basics.url, so the
//      printed CV can point at a landing page tracked separately from
//      the canonical homepage.
//   3. QR + portrait together — the two assets occupy opposite sides
//      with the header text filling the middle column.
//   4. QR + portrait with imagePosition: "left" — confirms the QR
//      follows the photo and ends up on the right.
//   5. QR themed by the document accent colour — exercises the
//      `fill: accent` path through the QR helper.

#import "../lib.typ": alta

#alta(
  (basics: (
    name: "QR From basics.url",
    label: "preferences.qrCode: \"url\"",
    email: "qr@example.com",
    url: "https://example.com/cv",
  )),
  preferences: (qrCode: "url"),
)

#pagebreak()

#alta(
  (basics: (
    name: "Explicit QR URL",
    label: "preferences.qrCode: \"https://...\"",
    email: "qr@example.com",
    url: "https://example.com/canonical",
  )),
  preferences: (qrCode: "https://example.com/printed-cv"),
)

#pagebreak()

#alta(
  (basics: (
    name: "QR + Portrait (Default)",
    label: "QR left, photo right",
    email: "qr@example.com",
    url: "https://example.com/cv",
    image: read("../examples/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (qrCode: "url"),
)

#pagebreak()

#alta(
  (basics: (
    name: "QR + Portrait (Flipped)",
    label: "Photo left, QR right",
    email: "qr@example.com",
    url: "https://example.com/cv",
    image: read("../examples/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (qrCode: "url", imagePosition: "left"),
)

#pagebreak()

#alta(
  (basics: (
    name: "Accent-Themed QR",
    label: "QR inherits preferences.accent",
    email: "qr@example.com",
    url: "https://example.com/cv",
  )),
  preferences: (qrCode: "url", accent: rgb("#1976D2")),
)
