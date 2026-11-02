// expect: labels.lang must be a lowercase ISO 639 code
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, labels: (lang: "Irish"))
