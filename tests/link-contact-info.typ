// The contact bar's links. `preferences.link-contact-info` accepts a
// boolean (apply uniformly) or a partial dict keyed by channel
// ("email", "phone", "location", "url", "profiles"); `basics.url`, JSON
// Resume's "personal homepage", renders with the `link` icon beside the
// other entries; `preferences.maps-provider` is the URL template (with
// a `{q}` placeholder for the URL-encoded location) the location links
// to, a `maps-providers` built-in or any other, or `none` for no link.
// Documents:
//
//   1. Bool `false` — no channel linked; icons + plain text only.
//   2. Dict overriding three channels — phone, location and homepage
//      render plain, email + profiles stay linked.
//   3. Bool `true` (default behaviour, asserted explicitly) — every
//      channel linked, the location to Google Maps (the default).
//   4. Bool `false` with `print-full-urls` — the unlinked GitHub
//      profile prints `github.com/janedoe` in place of its username.
//   5. `basics.url` alongside a "Website" profile — both render (the
//      template doesn't dedupe; semantically distinct "my homepage" vs
//      "a Website profile entry"), and the location links through a
//      URL template that isn't a built-in (Yandex Maps).
//
// The asserts at the end pin every link the documents draw, and each
// built-in provider's URL.

#import "../lib.typ": adapter, alta, maps-providers

#let cv = (
  basics: (
    name: "Jane Doe",
    label: "Software Engineer",
    email: "jane@example.com",
    phone: "+353 1 555 0100",
    location: "Dublin, Ireland",
    url: "https://janedoe.dev",
    profiles: (
      (
        network: "GitHub",
        username: "janedoe",
        url: "https://github.com/janedoe",
      ),
    ),
  ),
)

#alta(cv, preferences: (link-contact-info: false))

#pagebreak()

#alta(cv, preferences: (
  // Only phone, location and the homepage go plain; email and the
  // GitHub profile stay linked. Omitted channels default to true.
  link-contact-info: (phone: false, location: false, url: false),
))

#pagebreak()

#alta(cv, preferences: (link-contact-info: true))

#pagebreak()

#alta(cv, preferences: (link-contact-info: false, print-full-urls: true))

#pagebreak()

#alta(
  (
    basics: (
      name: "Jane Doe",
      label: "Homepage + Website profile",
      email: "jane@example.com",
      location: "Yerevan, Armenia",
      url: "https://janedoe.dev",
      profiles: (
        (
          network: "Website",
          username: "janedoe.dev",
          url: "https://janedoe.dev",
        ),
      ),
    ),
  ),
  preferences: (maps-provider: "https://yandex.com/maps/?text={q}"),
)

// Documents 1 and 4 link nothing.
#context assert.eq(
  query(link).map(l => l.dest),
  (
    // 2.
    "mailto:jane@example.com",
    "https://github.com/janedoe",
    // 3.
    "mailto:jane@example.com",
    "tel:+35315550100",
    "https://www.google.com/maps?q=Dublin%2C%20Ireland",
    "https://janedoe.dev",
    "https://github.com/janedoe",
    // 5.
    "mailto:jane@example.com",
    "https://yandex.com/maps/?text=Yerevan%2C%20Armenia",
    "https://janedoe.dev",
    "https://janedoe.dev",
  ),
)

// Each built-in provider, and `none`, as the location's link.
#let location-url(provider) = (
  adapter
    .basics-contacts((location: "Dublin, Ireland"), maps-provider: provider)
    .first()
    .url
)
#assert.eq(
  maps-providers.pairs().map(((k, v)) => (k, location-url(v))).to-dict(),
  (
    google: "https://www.google.com/maps?q=Dublin%2C%20Ireland",
    apple: "https://maps.apple.com/?q=Dublin%2C%20Ireland",
    bing: "https://www.bing.com/maps?q=Dublin%2C%20Ireland",
    duckduckgo: "https://duckduckgo.com/?q=Dublin%2C%20Ireland&iaxm=maps",
    osm: "https://www.openstreetmap.org/search?query=Dublin%2C%20Ireland",
  ),
)
#assert.eq(location-url(none), none)
