// expect: labels.lang isn't a label inside the altacv template: use `set text(lang: ..)`
#import "/lib.typ": alta, altacv

#show: altacv
#alta((basics: (name: "Jane Doe")), labels: (lang: "ga"))
