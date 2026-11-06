// expect: theme.stroke-width.thin must be a positive number, got: -1
#import "/lib.typ": altacv

#show: altacv.with(theme: (stroke-width: (thin: -1)))
