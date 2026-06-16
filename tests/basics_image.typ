// basics.image renders a circular portrait next to the header text.
// Documents exercise:
//   1. Bytes form — path resolution stays in the caller's typ file.
//   2. `path()` form (Typst 0.15.0+) — same resolution guarantee as
//      bytes, but as a reference rather than embedded bytes.
//   3. String path form (root-relative with leading "/").
//   4. Custom imageSize preference.
//   5. Photo on the LEFT with the default left-aligned text — the
//      "flipped header" layout. The text starts at a consistent edge
//      regardless of which side the photo is on; only the photo moves.
//   6. Photo on the left with explicit right-aligned text — the
//      "mirrored" look where each line ends at the page edge.
//   7. Centred header text on a no-image CV — `headerTextAlign`
//      applies whether or not `basics.image` is set.

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
    // path() carries its resolution anchor with it — even though
    // image() ultimately runs inside internal/header.typ, the file
    // is looked up relative to THIS test file.
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
