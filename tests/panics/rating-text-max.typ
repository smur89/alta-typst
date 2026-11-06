// expect: rating() max must be a positive integer, got: 0
#import "/lib.typ": rating

#rating("Irish", "Conversational", max: 0)
