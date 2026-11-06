// expect: font must be a font family name or a non-empty array of them, got: ()
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (font: ()))
