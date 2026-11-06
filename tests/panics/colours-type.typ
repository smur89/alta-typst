// expect: theme.colours must be a dictionary, got: rgb("#ff4136")
#import "/lib.typ": altacv

#show: altacv.with(theme: (colours: red))
