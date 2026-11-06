// expect: theme.colours.heading must be a colour (e.g. rgb("#1A3A6C")), got: "red"
#import "/lib.typ": altacv

#show: altacv.with(theme: (colours: (heading: "red")))
