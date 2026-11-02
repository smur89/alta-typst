// expect: Rating out of range
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (languages: ((language: "Irish", custom: (altacv: (rating: 6))),)))
