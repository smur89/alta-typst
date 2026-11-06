// expect: cv.basics.name must be set (a non-empty string; every other field is optional), got: (email: "x@example.com")
#import "/lib.typ": alta

#alta((basics: (email: "x@example.com")))
