// expect: Unknown theme key(s): "fonts"
#import "/lib.typ": altacv, themes

#show: altacv.with(theme: themes.navy + (fonts: "Lato"))
