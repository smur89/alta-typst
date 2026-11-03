// expect: work[].startDate must be a string or content, got: 2020
#import "/lib.typ": alta

#alta((basics: (name: "Jane Doe"), work: ((name: "Acme", startDate: 2020),)))
