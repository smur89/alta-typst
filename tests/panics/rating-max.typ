// expect: rating() max must be a positive integer
#import "/internal/components/ratings.typ": rating
#import "/lib.typ": alta

#alta((basics: (name: "Jane Doe")))
#rating("Irish", 1, max: 0)
