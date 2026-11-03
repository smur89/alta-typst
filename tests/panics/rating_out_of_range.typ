// expect: languages[].custom.altacv.rating must be between 0 and 5
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (languages: ((language: "Irish", custom: (altacv: (rating: 6))),)))
