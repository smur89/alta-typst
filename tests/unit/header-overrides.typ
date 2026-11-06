// The `cv-header` arguments a mapping overrides it with: the name in
// place of the document's title, the photo's size and shape, and the
// text following the surrounding alignment.

#import "/lib.typ": altacv, avatar-placeholder, cv-header

#show: altacv

#let titles = state("titles", ())
#show title: it => {
  titles.update(ts => ts + (it.body,))
  it
}
// The portrait's frame: the clipping box's width and corner radius.
#let frames = state("frames", ())
#show box: it => {
  if it.clip { frames.update(fs => fs + ((it.width, it.radius),)) }
  it
}

// A name with no document title; as given, `uppercase` aside.
#cv-header(name: "Jane Doe", uppercase: false)
#cv-header(name: [Seán O'Neil], uppercase: false)
#context assert.eq(titles.get(), ([Jane Doe], [Seán O'Neil]))

// `auto` is `alta()`'s default `image-size` and `image-shape`.
#cv-header(name: "A", photo: image(avatar-placeholder))
#cv-header(
  name: "B",
  photo: image(avatar-placeholder),
  photo-size: 3em,
  photo-shape: "square",
)
#context assert.eq(frames.get(), (
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
