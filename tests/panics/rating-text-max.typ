// expect: rating() max must be a positive integer
#import "/lib.typ": rating

#rating("Irish", "Conversational", max: 0)
