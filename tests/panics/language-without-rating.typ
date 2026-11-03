// expect: languages[].fluency must be a string when there's no numeric
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (languages: ((language: "Irish"),)))
