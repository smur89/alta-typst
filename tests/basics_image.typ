// Pages exercise each accepted source form (bytes, `path()`,
// root-relative string), an imageSize override, flipped/mirrored
// layouts, and centred header on a no-image CV.

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
    // Resolved against THIS file, not the package's internal/header.typ where image() runs.
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
  (basics: (
    name: "Large Photo",
    label: "imageSize: 8em override",
    email: "large@example.com",
    image: read("../assets/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (imageSize: 8em),
)

#pagebreak()

#alta(
  (basics: (
    name: "Left Photo, Default Text",
    label: "Photo flipped; text stays left-aligned",
    email: "left@example.com",
    image: read("../assets/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (imagePosition: "left"),
)

#pagebreak()

#alta(
  (basics: (
    name: "Left Photo, Right-Aligned Text",
    label: "Mirrored look — text hugs the right edge",
    email: "mirror@example.com",
    image: read("../assets/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (
    imagePosition: "left",
    headerTextAlign: "right",
  ),
)

#pagebreak()

// No image — `headerTextAlign: "center"` still applies, centring the
// name / label / contact bar block on the page.
#alta(
  (basics: (
    name: "Centred Header, No Photo",
    label: "headerTextAlign: \"center\"",
    email: "centre@example.com",
    phone: "+353 1 555 0100",
    location: "Dublin, Ireland",
  )),
  preferences: (headerTextAlign: "center"),
)
