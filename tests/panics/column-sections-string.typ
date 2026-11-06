// expect: right-column-sections must be an array of section keys (e.g. ("work",)), got: "skills"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (right-column-sections: "skills"))
