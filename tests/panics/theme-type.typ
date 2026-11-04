// expect: theme must be a theme (e.g. themes.altacv)
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (theme: "altacv"))
