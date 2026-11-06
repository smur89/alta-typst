// expect: theme.colours.name must be a colour
#import "/lib.typ": altacv

#show: altacv.with(theme: (colours: (name: "black")))
