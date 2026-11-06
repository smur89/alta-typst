// Inside the template, `alta()` draws through the JSON Resume mapping,
// yet a bare `basics.image` path still resolves from `internal/`, as it
// always has: not from the mapping's file, nor from the caller's
// (`../assets` from here would be `tests/assets`, which doesn't exist).

#import "/lib.typ": alta, altacv

#show: altacv

#let images = state("images", 0)
#show image: it => {
  images.update(n => n + 1)
  it
}

#alta((
  basics: (name: "Jane Doe", image: "../assets/avatar-placeholder.svg"),
))
#context assert.eq(images.final(), 1)
