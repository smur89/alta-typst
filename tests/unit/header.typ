// Unit checks for sections/header.typ's image and QR URL resolution.
// The contact entries it draws are `adapter.basics-contacts`'s, in
// adapter.typ.

#import "/sections/header.typ": _header-image, _resolve-qr-url

// _resolve-qr-url: none stays off, a string is used verbatim, auto
// reads basics.url.
#assert.eq(_resolve-qr-url(none, (:)), none)
#assert.eq(_resolve-qr-url("https://a.example", (:)), "https://a.example")
#assert.eq(
  _resolve-qr-url(auto, (url: "https://b.example")),
  "https://b.example",
)

// _header-image: an empty string path is absent.
#assert.eq(_header-image(""), none)
#assert.eq(_header-image(none), none)
