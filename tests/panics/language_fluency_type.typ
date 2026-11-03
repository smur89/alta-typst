// expect: languages[].fluency must be a string
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (languages: ((language: "Irish", fluency: 3),)))
