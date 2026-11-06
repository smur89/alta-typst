// expect: theme.type.headline.size must be a positive number
#import "/lib.typ": altacv

#show: altacv.with(theme: (type: (headline: (size: "big"))))
