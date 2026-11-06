// expect: basics.location.city must be a string when a maps-provider is set, got: [Cork]
#import "/lib.typ": alta

#alta((basics: (name: "Jane Doe", location: (city: [Cork]))))
