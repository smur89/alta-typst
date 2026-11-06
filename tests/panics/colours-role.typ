// expect: theme.colours.heading must be a colour
#import "/lib.typ": altacv

#show: altacv.with(theme: (colours: (heading: "red")))
