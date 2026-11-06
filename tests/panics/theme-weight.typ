// expect: theme.type.headline.weight must be a font weight ("regular", "bold", … or 100 to 900), got: "heavyy"
#import "/lib.typ": altacv

#show: altacv.with(theme: (type: (headline: (weight: "heavyy"))))
