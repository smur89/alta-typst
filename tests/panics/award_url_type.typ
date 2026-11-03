// expect: awards[].custom.altacv.url must be a string, got: 5
#import "/lib.typ": alta

#alta((
  basics: (name: "Jane Doe"),
  awards: ((title: "Prize", custom: (altacv: (url: 5))),),
))
