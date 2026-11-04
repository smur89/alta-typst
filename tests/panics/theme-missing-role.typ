// expect: theme.colours must set every role; missing: ("name",)
#import "/lib.typ": alta, themes

#let cv = (basics: (name: "Jane Doe"))
#let colours = themes.navy.colours
#alta(cv, preferences: (
  theme: (colours: colours.pairs().filter(((k, _)) => k != "name").to-dict()),
))
