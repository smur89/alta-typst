// basics.image renders a circular portrait top-right of the header.
// Three documents exercise:
//   1. Bytes form — the recommended way (path resolution stays in
//      the caller's typ file).
//   2. String path form (root-relative with leading "/").
//   3. Custom imageSize preference.

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
