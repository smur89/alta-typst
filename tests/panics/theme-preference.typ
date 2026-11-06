// expect: preferences.theme isn't an alta() preference: theme the CV with `#show: altacv.with(theme: themes.navy)`
#import "/lib.typ": alta, themes

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (theme: themes.navy))
