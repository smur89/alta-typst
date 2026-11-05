// expect: labels.publication-types has keys that collide after lowercasing
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, labels: (publication-types: (Talk: "Talks", talk: "Talks")))
