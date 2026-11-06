// expect: location-parts() location.city must be a string or content, got: 5
#import "/lib.typ": adapter

#adapter.location-parts((city: 5))
