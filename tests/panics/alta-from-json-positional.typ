// expect: alta-from-json takes one positional (`data`); pass labels/preferences as named arguments. Got extra positionals: ((:),)
#import "/lib.typ": alta-from-json

#alta-from-json((basics: (name: "Jane Doe")), (:))
