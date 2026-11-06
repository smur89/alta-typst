// expect: languages[].custom.altacv.rating must be a multiple of 0.5, got: 2.3
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (languages: ((language: "Irish", custom: (altacv: (rating: 2.3))),)))
