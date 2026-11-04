// expect: skillLevelDisplay must be `auto`, "rating" or "text"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (skillLevelDisplay: "dots"))
