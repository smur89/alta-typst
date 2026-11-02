// expect: rating() max must be a positive integer
#import "/lib.typ": alta, rating

#alta((basics: (name: "Jane Doe")))
#rating("Irish", 1, max: 0)
