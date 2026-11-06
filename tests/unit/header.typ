// The header: sections/header.typ's image and QR URL resolution,
// and the `cv-header` block. The document's title is the name, set
// once as Typst's `title` element, unless a mapping passes `name`;
// the photo frames the user's image, at `alta()`'s size and shape
// unless given; contacts' alt text reads as `alta()`'s does; the
// text follows the surrounding alignment. The contact entries
// `alta()` draws are `adapter.basics-contacts`'s, in adapter.typ.

#import "/lib.typ": altacv, avatar-placeholder, contact, cv-header
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

#set document(title: [Seán O'Neil])
#show: altacv

#let titles = state("titles", ())
#show title: it => {
  titles.update(ts => ts + (it.body,))
  it
}
// Each image's fit and alt, as set rules resolve them.
#let images = state("images", ())
#show image: it => {
  images.update(xs => xs + ((it.fit, it.alt),))
  it
}
// The alt text of each contact icon that has one.
#let alts = state("alts", ())
#show figure: it => {
  alts.update(xs => xs + (it.alt,))
  it
}

#cv-header(
  tagline: "Engineer",
  contacts: (
    contact("email", "j@d.ie", url: "mailto:j@d.ie"),
    contact("phone", "+353 1 234 5678"),
    contact("link", "example.com", url: "https://example.com"),
    contact("location", "Dublin"),
    contact("github", "sean"),
    contact("email", "s@d.ie", alt: "Work email"),
  ),
  photo: image(avatar-placeholder),
)
#metadata(none)<first>

// One title, the name; `uppercase` wraps it in `upper`.
#context assert.eq(
  titles.at(locate(<first>)),
  (upper([Seán O'Neil]),),
)
// A bare image is framed (`cover`) and reads the name, apostrophe kept.
#context assert.eq(
  images.at(locate(<first>)),
  (("cover", "Seán O'Neil"),),
)
// Email, phone and a homepage read nothing; a location the localised
// word, a profile its network; an explicit alt wins.
#context assert.eq(
  alts.at(locate(<first>)),
  ("Location", "github", "Work email"),
)

// The user's own fit and alt win over the photo's.
#cv-header(photo: image(avatar-placeholder, fit: "contain", alt: "Me"))
#metadata(none)<second>
#context assert.eq(
  images.at(locate(<second>)).at(-1),
  ("contain", "Me"),
)

// The location's alt follows the document's language.
#[
  #set text(lang: "ga")
  #cv-header(contacts: (contact("location", "Baile Átha Cliath"),))
  #metadata(none)<third>
]
#context assert.eq(alts.at(locate(<third>)).at(-1), "Suíomh")

// The photo's frame: the clipping box's width and corner radius.
#let frames = state("frames", ())
#show box: it => {
  if it.clip { frames.update(fs => fs + ((it.width, it.radius),)) }
  it
}

// A name in place of the document's title; as given, `uppercase`
// aside.
#cv-header(name: "Jane Doe", uppercase: false)
#cv-header(name: [Seán O'Neil], uppercase: false)
#metadata(none)<named>
#context assert.eq(
  titles.at(locate(<named>)).slice(-2),
  ([Jane Doe], [Seán O'Neil]),
)

// `auto` is `alta()`'s default `photo-size` and `photo-shape`.
#cv-header(name: "A", photo: image(avatar-placeholder))
#cv-header(
  name: "B",
  photo: image(avatar-placeholder),
  photo-size: 3em,
  photo-shape: "square",
)
#metadata(none)<framed>
#context assert.eq(frames.at(locate(<framed>)).slice(-2), (
  (0% + 6em, 50% + 0pt),
  (0% + 3em, 0% + 0pt),
))

// The name's left edge, by where the header sits: `start` by default,
// as `left` was, and the surrounding `align`'s otherwise.
#cv-header(name: "Jane Doe")
#align(left, cv-header(name: "Jane Doe"))
#align(center, cv-header(name: "Jane Doe"))
#align(right, cv-header(name: "Jane Doe"))
#context {
  let (default, left, centre, right) = query(<alta-name>)
    .slice(-4)
    .map(t => t.location().position().x)
  assert.eq(default, left)
  assert(left < centre and centre < right)
}
