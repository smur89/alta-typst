// expect: theme.font must be a font family name or a non-empty array of them, got: 12
#import "/lib.typ": altacv

#show: altacv.with(theme: (font: 12))
