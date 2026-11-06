// The `cv-header` block: the document's title is the name, set once
// as Typst's `title` element; the photo frames the user's image;
// contacts' alt text reads as `alta()`'s does.

#import "/lib.typ": altacv, avatar-placeholder, contact, cv-header

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
    contact("email", "j@d.ie", link: "mailto:j@d.ie"),
    contact("phone", "+353 1 234 5678"),
    contact("link", "example.com", link: "https://example.com"),
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
