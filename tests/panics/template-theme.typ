// expect: theme must be a theme (e.g. themes.altacv), got: "navy"
#import "/lib.typ": altacv

#show: altacv.with(theme: "navy")
