// expect: basics.location.city must be a string when a maps-provider is set, got: 5
#import "/lib.typ": alta

#alta((basics: (name: "Jane Doe", location: (city: 5, postalCode: 12345))))
