// expect: theme.colours.name must be a colour
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (theme: (colours: (name: "black"))))
