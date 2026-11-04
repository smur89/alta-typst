// expect: colours.heading must be `auto` or a colour
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (colours: (heading: "red")))
