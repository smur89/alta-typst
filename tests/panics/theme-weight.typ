// expect: theme.type.headline.weight must be a font weight
#import "/lib.typ": altacv

#show: altacv.with(theme: (type: (headline: (weight: "heavyy"))))
