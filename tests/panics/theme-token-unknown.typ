// expect: Unknown theme.space key(s): "huge"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (theme: (space: (huge: 2))))
