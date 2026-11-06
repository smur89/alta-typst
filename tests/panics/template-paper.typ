// expect: preferences.paper isn't an alta() preference inside the altacv template: use `set page(paper: ..)` after `#show: altacv.with(..)`.
#import "/lib.typ": alta, altacv

#show: altacv
#alta((basics: (name: "Jane Doe")), preferences: (paper: "a5"))
