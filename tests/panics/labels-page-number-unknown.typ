// expect: labels.page-number has unknown placeholder(s) ("{totl}",); allowed: ("{current}", "{total}"). Got: "{current} / {totl}"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, labels: (page-number: "{current} / {totl}"))
