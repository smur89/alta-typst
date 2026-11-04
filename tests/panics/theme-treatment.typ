// expect: theme.treatment.link must be
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (theme: (treatment: (link: "bold"))))
