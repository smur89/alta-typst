// expect: labels.lang isn't an altacv() label: use `set text(lang: ..)`
#import "/lib.typ": altacv

#show: altacv.with(labels: (lang: "de"))
