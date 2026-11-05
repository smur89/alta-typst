// expect: Unknown date-format token: [hour]
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (work: ((name: "Acme", startDate: "2024-06"),)), preferences: (
  date-format: "[hour] [year]",
))
