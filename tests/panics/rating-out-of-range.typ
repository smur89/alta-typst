// expect: languages[].custom.altacv.rating must be between 0 and 5, got: 6
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (languages: ((language: "Irish", custom: (altacv: (rating: 6))),)))
