// expect: date-format must be "long", "short", "iso", a bracketed template (e.g. "[day]/[month]/[year]"), or a closure, got: "medium"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (date-format: "medium"))
