// expect: skill-level-display must be `auto`, "rating" or "text", got: "dots"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (skill-level-display: "dots"))
