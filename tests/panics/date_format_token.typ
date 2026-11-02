// expect: Unknown dateFormat token: [hour]
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv + (work: ((name: "Acme", startDate: "2024-06"),)), preferences: (
  dateFormat: "[hour] [year]",
))
