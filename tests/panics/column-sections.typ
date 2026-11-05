// expect: Unknown left-column-sections key(s): "jobs"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (left-column-sections: ("jobs",)))
