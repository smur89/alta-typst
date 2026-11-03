// expect: work[].highlights must be an array of strings or content, got: "abc"
#import "/lib.typ": alta

#alta((basics: (name: "Jane Doe"), work: ((name: "Acme", highlights: "abc"),)))
