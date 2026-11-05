// expect: preferences.publication-icons must be a dictionary
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (publication-icons: "microphone"))
