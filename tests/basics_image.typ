// basics.image renders a circular portrait next to the header text.
// Documents exercise:
//   1. Bytes form — the recommended way (path resolution stays in
//      the caller's typ file).
//   2. String path form (root-relative with leading "/").
//   3. Custom imageSize preference.
//   4. Photo on the LEFT with the default left-aligned text — the
//      "flipped header" layout. The text starts at a consistent edge
//      regardless of which side the photo is on; only the photo moves.
//   5. Photo on the left with explicit right-aligned text — the
//      "mirrored" look where each line ends at the page edge.

#import "../lib.typ": alta

#alta((
  basics: (
    name: "Jane Doe",
    label: "Senior Software Engineer",
    email: "jane@example.com",
    location: "Dublin, Ireland",
    image: read("../examples/avatar-placeholder.svg", encoding: none),
  ),
))

#pagebreak()

#alta((
  basics: (
    name: "Path User",
    label: "String path form",
    email: "path@example.com",
    // Root-relative path. The leading "/" anchors resolution to the
    // --root directory rather than the caller's file location.
    image: "/examples/avatar-placeholder.svg",
  ),
))

#pagebreak()

#alta(
  (basics: (
    name: "Large Photo",
    label: "imageSize: 8em override",
    email: "large@example.com",
    image: read("../examples/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (imageSize: 8em),
)

#pagebreak()

#alta(
  (basics: (
    name: "Left Photo, Default Text",
    label: "Photo flipped; text stays left-aligned",
    email: "left@example.com",
    image: read("../examples/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (imagePosition: "left"),
)

#pagebreak()

#alta(
  (basics: (
    name: "Left Photo, Right-Aligned Text",
    label: "Mirrored look — text hugs the right edge",
    email: "mirror@example.com",
    image: read("../examples/avatar-placeholder.svg", encoding: none),
  )),
  preferences: (
    imagePosition: "left",
    headerTextAlign: "right",
  ),
)
