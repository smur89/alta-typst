// expect: Unknown leftColumnSections key(s): "jobs"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (leftColumnSections: ("jobs",)))
