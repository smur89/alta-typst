// expect: Language entry needs either a numeric
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (languages: ((language: "Irish"),)))
