// expect: preferences.paper isn't an alta() preference inside the altacv template
#import "/lib.typ": alta, altacv

#show: altacv
#alta((basics: (name: "Jane Doe")), preferences: (paper: "a5"))
