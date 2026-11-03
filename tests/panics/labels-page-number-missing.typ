// expect: labels.pageNumber must contain {current}
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, labels: (pageNumber: "Page"))
