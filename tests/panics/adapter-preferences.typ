// expect: column-ratio must be a number in (0, 1], got: 2
#import "/lib.typ": adapter

#adapter.preferences(overrides: (column-ratio: 2))
