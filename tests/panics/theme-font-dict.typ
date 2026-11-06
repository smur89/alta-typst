// expect: theme.font must be a font family name
#import "/lib.typ": altacv

#show: altacv.with(theme: (font: ((unexpected: "Lato"),)))
