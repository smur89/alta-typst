// Header QR matrix — opt-in via `preferences.qrCode`. Printed CVs lose
// the clickability of digital PDFs; a QR code rescues that one link
// the reader is most likely to follow (the homepage URL). Off by
// default — turn it on with `preferences.qrCode: "url"` (encode
// `basics.url`) or any literal URL string.
//
// Generation is delegated to `@preview/zebra`, the only third-party
// Typst dependency this package pulls in. Zebra emits native Typst
// vector paths (not a rasterised image), so the matrix stays crisp at
// any size and inherits a `fill` colour like any other shape. The
// dependency is fetched on first compile and cached thereafter.
//
// This module owns three concerns and nothing else: validating the
// preference value, resolving it against `basics.url`, and rendering
// the matrix wrapped in `link()`. `internal/header.typ` consumes
// `_qr_render` and composes the result into the header layout — the
// header file doesn't import zebra directly, so swapping QR
// implementations stays a one-file change.

#import "@preview/zebra:0.1.0": qrcode

// Validates `preferences.qrCode`. Accepted shapes:
//   - `none`              — no QR rendered
//   - the string `"url"`  — encode `basics.url` at render time
//   - any other non-empty string — encode that string verbatim
// Anything else panics with a message anchored at the preferences
// call site, so a typo (`qrCode: true`, `qrCode: 42`) surfaces up
// front rather than as a render-time failure inside `qrcode(...)`.
#let _check_qr_code(value) = {
  if value == none { return }
  if type(value) != str {
    panic(
      "qrCode must be `none`, the string \"url\", or a URL string, got: "
        + repr(value),
    )
  }
  if value == "" {
    panic("qrCode must be a non-empty string when not `none`.")
  }
}

// Resolves the validated preference against `basics`. Returns the URL
// string to encode, or `none` when no QR should render. Separated
// from `_check_qr_code` because the `"url"` lookup depends on `basics`
// — only callable once `alta()` has the data dict in hand.
#let _resolve_qr_url(qr-code, basics) = {
  if qr-code == none { return none }
  if qr-code != "url" { return qr-code }
  let url = basics.at("url", default: none)
  if url == none {
    panic(
      "preferences.qrCode is \"url\" but basics.url is missing. "
        + "Set basics.url to the destination URL, or pass the URL "
        + "directly via preferences.qrCode.",
    )
  }
  if type(url) != str {
    panic("basics.url must be a string, got: " + repr(url))
  }
  if url == "" {
    panic(
      "basics.url is empty; set it to the destination URL or remove preferences.qrCode.",
    )
  }
  url
}

// `quiet-zone: 0` because the surrounding header padding already
// supplies plenty of whitespace; zebra's default 4-module quiet zone
// would otherwise shrink the dark matrix and make it harder to scan
// at the small print size we target. Passing only `width` (not also
// `height`) lets zebra infer the missing dimension — a QR is square
// by construction, so this keeps the matrix from stretching if the
// surrounding box ever changes shape.
//
// The matrix is wrapped in `link()` so a digital PDF reader can
// click through to the same destination the QR encodes — the QR
// is for print, the click is for screen.
#let _qr_render(url, size, fill) = link(
  url,
  qrcode(url, width: size, quiet-zone: 0, fill: fill),
)
