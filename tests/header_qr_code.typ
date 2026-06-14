// `preferences.qrCode` renders a small QR matrix in the header on the
// side opposite the portrait — restoring one click of digital-PDF
// affordance when the CV is printed. Documents exercise:
//
//   1. `auto` form — encodes `basics.url`, no portrait. QR lands on
//      the side opposite `imagePosition` (default `"right"` → QR on
//      the left).
//   2. Explicit URL string — distinct from `basics.url`, so the
//      printed CV can point at a landing page tracked separately from
//      the canonical homepage.
//   3. QR + portrait together — the two ornaments occupy opposite
//      sides with the header text filling the middle column.
//   4. QR + portrait with `imagePosition: "left"` — confirms the QR
//      follows the photo and ends up on the right.
//   5. QR themed by a custom `accent` colour — exercises the
//      `fill: accent` path through the QR helper.
//   6. QR alongside a centred portrait — QR rides the page-left edge
//      while the photo stays stacked above the centred-header text.
//   7. QR with no portrait + `imagePosition: "center"` — QR at the
//      page-left edge, centred-header text spans the rest.
//   8. Centred portrait + QR with `imageStackOrder: "below"` — photo
//      stacks under the text-row; QR still rides the page-left edge.
//   9. Centred portrait + QR + `headerTextAlign: "left"` — orthogonal
//      case: centred-photo axis preserved while header text sits flush
//      left of the QR's column-mate spacer.

#import "../lib.typ": alta

#alta(
  (basics: (
    name: "QR From basics.url",
    label: "preferences.qrCode: auto",
    email: "qr@example.com",
    url: "https://example.com/cv",
  )),
  preferences: (qrCode: auto),
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
    image: read("../icons/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (qrCode: auto),
)

#pagebreak()

#alta(
  (basics: (
    name: "QR + Portrait (Flipped)",
    label: "Photo left, QR right",
    email: "qr@example.com",
    url: "https://example.com/cv",
    image: read("../icons/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (qrCode: auto, imagePosition: "left"),
)

#pagebreak()

#alta(
  (basics: (
    name: "Accent-Themed QR",
    label: "QR inherits preferences.accent",
    email: "qr@example.com",
    url: "https://example.com/cv",
  )),
  preferences: (qrCode: auto, accent: rgb("#1976D2")),
)

#pagebreak()

#alta(
  (basics: (
    name: "Centred Portrait + QR",
    label: "QR rides page-left, photo stacks centred above",
    email: "qr@example.com",
    url: "https://example.com/cv",
    image: read("../icons/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (
    qrCode: auto,
    imagePosition: "center",
    headerTextAlign: "center",
  ),
)

#pagebreak()

#alta(
  (basics: (
    name: "Centred Text + QR (No Photo)",
    label: "QR rides page-left, centred header spans the rest",
    email: "qr@example.com",
    url: "https://example.com/cv",
  )),
  preferences: (
    qrCode: auto,
    imagePosition: "center",
    headerTextAlign: "center",
  ),
)

#pagebreak()

#alta(
  (basics: (
    name: "Centred Photo Below + QR",
    label: "imageStackOrder: \"below\" — photo trails the text block",
    email: "qr@example.com",
    url: "https://example.com/cv",
    image: read("../icons/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (
    qrCode: auto,
    imagePosition: "center",
    imageStackOrder: "below",
    headerTextAlign: "center",
  ),
)

#pagebreak()

#alta(
  (basics: (
    name: "Centred Photo + Left Text + QR",
    label: "Orthogonal axes — photo centred, header text left-aligned",
    email: "qr@example.com",
    url: "https://example.com/cv",
    image: read("../icons/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (
    qrCode: auto,
    imagePosition: "center",
  ),
)
