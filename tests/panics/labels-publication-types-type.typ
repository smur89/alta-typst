// expect: labels.publication-types must be a dictionary, got: "Talks"
#import "/lib.typ": alta

#alta((basics: (name: "Jane Doe")), labels: (publication-types: "Talks"))
