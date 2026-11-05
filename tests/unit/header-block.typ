// The `cv-header` block: the document's title is the name, set once
// as Typst's `title` element.

#import "/lib.typ": altacv, contact, cv-header

#set document(title: "Jane Doe")
#show: altacv

#let titles = state("titles", ())
#show title: it => {
  titles.update(ts => ts + (it.body,))
  it
}

#cv-header(
  tagline: "Engineer",
  contacts: (contact("email", "j@d.ie", link: "mailto:j@d.ie"),),
)

// `uppercase` wraps the name in `upper`.
#context assert.eq(titles.final(), (upper([Jane Doe]),))
