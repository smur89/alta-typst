// expect: labels.page-number must contain {current}. Got: "Page"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, labels: (page-number: "Page"))
