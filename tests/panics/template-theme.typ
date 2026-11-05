// expect: preferences.theme isn't an alta() preference inside the altacv template
#import "/lib.typ": alta, altacv, themes

#show: altacv
#alta((basics: (name: "Jane Doe")), preferences: (theme: themes.navy))
