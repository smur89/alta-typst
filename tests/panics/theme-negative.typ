// expect: theme.stroke-width.thin must be a positive number
#import "/lib.typ": altacv

#show: altacv.with(theme: (stroke-width: (thin: -1)))
