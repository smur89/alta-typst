// expect: location-text() location.city must be a string or content, got: 5
#import "/lib.typ": adapter

#adapter.location-text((city: 5))
