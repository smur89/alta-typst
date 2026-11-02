// expect: labels.publicationTypes has keys that collide after lowercasing
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, labels: (publicationTypes: (Talk: "Talks", talk: "Talks")))
