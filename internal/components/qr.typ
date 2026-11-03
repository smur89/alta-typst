// Header QR code (opt-in via `preferences.qrCode`), restoring the
// most-followed link on a printed CV. Renders the code;
// `data/validation.typ` checks the preference and `sections/header.typ`
// resolves its target. Only this file imports `@preview/zebra`, so
// swapping QR implementations stays a one-file change. Zebra emits vector
// paths, so the matrix stays crisp and takes a `fill` like any shape.

#import "@preview/zebra:0.1.0": qrcode

// `quiet-zone: 0`: the header padding already supplies whitespace, and
// zebra's default 4-module zone would shrink the matrix.
//
// Neither zebra's output nor `link` takes alt text, so the matrix goes
// in `figure(alt: url)`, Typst's carrier for alt text on non-image
// content in tagged PDF. Unnumbered, unoutlined and gap-free, it
// leaves the layout unchanged.
#let _qr_render(url, size, fill) = link(
  url,
  figure(
    qrcode(url, width: size, quiet-zone: 0, fill: fill),
    alt: url,
    numbering: none,
    outlined: false,
    gap: 0pt,
  ),
)
