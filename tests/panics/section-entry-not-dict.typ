// expect: skills entries must be dictionary
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (skills: ("Typst",)))
