// expect: labels.lang isn't a label inside the altacv template: use `set text(lang: ..)`
#import "/lib.typ": altacv

#show: altacv.with(labels: (lang: "de"))
