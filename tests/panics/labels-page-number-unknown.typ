// expect: labels.pageNumber has unknown placeholder(s)
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, labels: (pageNumber: "{current} / {totl}"))
