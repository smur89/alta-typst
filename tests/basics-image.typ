// Pages exercise each accepted source form (bytes, `path()`,
// root-relative string), a `photo-size` override, flipped/mirrored
// layouts, centred header on a no-image CV, and the rounded and
// square `photo-shape`s.

#import "../lib.typ": alta

#alta((
  basics: (
    name: "Jane Doe",
    label: "Senior Software Engineer",
    email: "jane@example.com",
    location: "Dublin, Ireland",
    image: read("../assets/avatar-placeholder.svg", encoding: none),
  ),
))

#pagebreak()

#alta((
  basics: (
    name: "Path User",
    label: "path() form",
    email: "path@example.com",
    // Resolved against THIS file, not the package's internal/primitives.typ where image() runs.
    image: path("../assets/avatar-placeholder.svg"),
  ),
))

#pagebreak()

#alta((
  basics: (
    name: "Root User",
    label: "String path form",
    email: "root@example.com",
    // Root-relative path. The leading "/" anchors resolution to the
    // --root directory rather than the caller's file location.
    image: "/assets/avatar-placeholder.svg",
  ),
))

#pagebreak()

#alta(
  (
    basics: (
      name: "Large Photo",
      label: "image-size: 8em override",
      email: "large@example.com",
      image: read("../assets/avatar-placeholder.svg", encoding: none),
    ),
  ),
  preferences: (photo-size: 8em),
)

#pagebreak()

#alta(
  (
    basics: (
      name: "Left Photo, Default Text",
      label: "Photo flipped; text stays left-aligned",
      email: "left@example.com",
      image: read("../assets/avatar-placeholder.svg", encoding: none),
    ),
  ),
  preferences: (photo-position: left),
)

#pagebreak()

#alta(
  (
    basics: (
      name: "Left Photo, Right-Aligned Text",
      label: "Mirrored look — text hugs the right edge",
      email: "mirror@example.com",
      image: read("../assets/avatar-placeholder.svg", encoding: none),
    ),
  ),
  preferences: (
    photo-position: left,
    header-text-align: right,
  ),
)

#pagebreak()

// No image — `header-text-align: center` still applies, centring the
// name / label / contact bar block on the page.
#alta(
  (
    basics: (
      name: "Centred Header, No Photo",
      label: "header-text-align: center",
      email: "centre@example.com",
      phone: "+353 1 555 0100",
      location: "Dublin, Ireland",
    ),
  ),
  preferences: (header-text-align: center),
)

#for shape in ("rounded", "square") {
  pagebreak()
  alta(
    (
      basics: (
        name: "Shaped Photo",
        label: "image-shape: " + repr(shape),
        email: "shape@example.com",
        image: read("../assets/avatar-placeholder.svg", encoding: none),
      ),
    ),
    preferences: (photo-shape: shape),
  )
}
