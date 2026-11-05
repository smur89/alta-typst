// expect: labels.page-number has unknown placeholder(s)
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, labels: (page-number: "{current} / {totl}"))
