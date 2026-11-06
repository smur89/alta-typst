// expect: labels.publication-icons must be a dictionary, got: "microphone"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, labels: (publication-icons: "microphone"))
