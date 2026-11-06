// Location values 1.8.0 accepted still compile: `address` and
// `postalCode`, which altacv doesn't show, take any type, and with
// `maps-provider: none` a `basics.location` value isn't type-checked
// (no maps link URL-encodes it). Content renders there.

#import "/lib.typ": alta

#let cv(location) = (
  basics: (name: "Jane Doe", location: location),
  work: ((name: "Acme", location: location),),
)

#alta(cv((city: "Cork", postalCode: 12345)))
#alta(cv((city: "Cork", address: 5)))
#alta(cv((city: "Cork", address: [1 Main Street])))
#alta(cv((city: "Cork", address: ("1 Main Street", "Cork"))))
#alta(
  (basics: (name: "Jane Doe", location: (city: 5))),
  preferences: (maps-provider: none),
)

#let seen = state("seen", 0)
#show "Corcaigh": it => {
  seen.update(n => n + 1)
  it
}
#alta(cv((city: [Corcaigh])), preferences: (maps-provider: none))
#context assert.eq(seen.final(), 2)
