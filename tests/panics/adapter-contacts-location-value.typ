// expect: basics-contacts() location.city must be a string when a maps-provider is set, got: 5
#import "/lib.typ": adapter

#adapter.basics-contacts((location: (city: 5)))
