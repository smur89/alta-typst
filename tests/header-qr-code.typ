// `preferences.qr-code` renders a small QR matrix in the header on the
// side opposite the photo — restoring one click of digital-PDF
// affordance when the CV is printed. Documents exercise:
//
//   1. `auto` form — encodes `basics.url`, no photo. QR lands on
//      the side opposite `photo-position` (default `right` → QR on
//      the left).
//   2. Explicit URL string — distinct from `basics.url`, so the
//      printed CV can point at a landing page tracked separately from
//      the canonical homepage.
//   3. QR + photo together — the two ornaments occupy opposite
//      sides with the header text filling the middle column.
//   4. QR + photo with `photo-position: left` — confirms the QR
//      follows the photo and ends up on the right.
//   5. QR themed by a custom `colours.accent` — exercises the
//      `fill: accent` path through the QR helper.
//   6. QR alongside a centred photo — QR pins the top-left corner
//      next to the photo (top row), with the centred-header text in a
//      separate row below.
//   7. QR with no photo + `photo-position: top` — top row is the
//      header text; QR pins its top-left corner.
//   8. Centred photo + QR with `photo-position: bottom` — text on
//      top, photo trails below; QR pins the text row's top-left corner.
//   9. Centred photo + QR + `header-text-align: left` — orthogonal
//      case: photo + QR share the top row (photo centred page-wise,
//      QR top-left), text sits flush-left in a row below.

#import "../lib.typ": alta

#alta(
  (
    basics: (
      name: "QR From basics.url",
      label: "preferences.qr-code: auto",
      email: "qr@example.com",
      url: "https://example.com/cv",
    ),
  ),
  preferences: (qr-code: auto),
)

#pagebreak()

#alta(
  (
    basics: (
      name: "Explicit QR URL",
      label: "preferences.qr-code: \"https://...\"",
      email: "qr@example.com",
      url: "https://example.com/canonical",
    ),
  ),
  preferences: (qr-code: "https://example.com/printed-cv"),
)

#pagebreak()

#alta(
  (
    basics: (
      name: "QR + Portrait (Default)",
      label: "QR left, photo right",
      email: "qr@example.com",
      url: "https://example.com/cv",
      image: read("../assets/avatar-placeholder.svg", encoding: none),
    ),
  ),
  preferences: (qr-code: auto),
)

#pagebreak()

#alta(
  (
    basics: (
      name: "QR + Portrait (Flipped)",
      label: "Photo left, QR right",
      email: "qr@example.com",
      url: "https://example.com/cv",
      image: read("../assets/avatar-placeholder.svg", encoding: none),
    ),
  ),
  preferences: (qr-code: auto, photo-position: left),
)

#pagebreak()

#alta(
  (
    basics: (
      name: "Accent-Themed QR",
      label: "QR inherits preferences.colours.accent",
      email: "qr@example.com",
      url: "https://example.com/cv",
    ),
  ),
  preferences: (qr-code: auto, colours: (accent: rgb("#1976D2"))),
)

#pagebreak()

#alta(
  (
    basics: (
      name: "Centred Portrait + QR",
      label: "QR pins top-left next to the photo, text below",
      email: "qr@example.com",
      url: "https://example.com/cv",
      image: read("../assets/avatar-placeholder.svg", encoding: none),
    ),
  ),
  preferences: (
    qr-code: auto,
    photo-position: top,
    header-text-align: center,
  ),
)

#pagebreak()

#alta(
  (
    basics: (
      name: "Centred Text + QR (No Photo)",
      label: "QR pins top-left, centred header fills the row",
      email: "qr@example.com",
      url: "https://example.com/cv",
    ),
  ),
  preferences: (
    qr-code: auto,
    photo-position: top,
    header-text-align: center,
  ),
)

#pagebreak()

#alta(
  (
    basics: (
      name: "Centred Photo Below + QR",
      label: "image-position: bottom — photo trails the text block",
      email: "qr@example.com",
      url: "https://example.com/cv",
      image: read("../assets/avatar-placeholder.svg", encoding: none),
    ),
  ),
  preferences: (
    qr-code: auto,
    photo-position: bottom,
    header-text-align: center,
  ),
)

#pagebreak()

#alta(
  (
    basics: (
      name: "Centred Photo + Left Text + QR",
      label: "Orthogonal axes — photo centred, header text left-aligned",
      email: "qr@example.com",
      url: "https://example.com/cv",
      image: read("../assets/avatar-placeholder.svg", encoding: none),
    ),
  ),
  preferences: (
    qr-code: auto,
    photo-position: top,
    header-text-align: left,
  ),
)
