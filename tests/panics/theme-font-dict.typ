// expect: theme.font must be a font family name or a non-empty array of them, got: ((unexpected: "Lato"),)
#import "/lib.typ": altacv

#show: altacv.with(theme: (font: ((unexpected: "Lato"),)))
