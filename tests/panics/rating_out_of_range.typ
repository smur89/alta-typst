// expect: rating value must be between 0 and
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (languages: ((language: "Irish", custom: (altacv: (rating: 6))),)))
