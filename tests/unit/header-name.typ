// `cv-header(name: ..)`, as a mapping passes it, in a document with no
// title to fall back on: the name is the `title` element, as given,
// `uppercase` aside. Apart from header.typ, which sets a title.

#import "/lib.typ": altacv, cv-header

#show: altacv

#let titles = state("titles", ())
#show title: it => {
  titles.update(ts => ts + (it.body,))
  it
}

#cv-header(name: "Jane Doe", uppercase: false)
#cv-header(name: [Máire Ní Bhriain], uppercase: false)
#context assert.eq(titles.final(), ([Jane Doe], [Máire Ní Bhriain]))
