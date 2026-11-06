// expect: basics.image must be a path, a string path, or bytes, got: 42
#import "/lib.typ": alta

#alta((basics: (name: "Jane Doe", image: 42)))
