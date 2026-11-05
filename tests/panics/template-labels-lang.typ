// expect: labels.lang isn't an alta() label inside the altacv template
#import "/lib.typ": alta, altacv

#show: altacv
#alta((basics: (name: "Jane Doe")), labels: (lang: "ga"))
