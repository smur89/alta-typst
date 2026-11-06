// expect: preferences.body-size isn't an alta() preference inside the altacv template: use `set text(size: ..)` after `#show: altacv.with(..)`.
#import "/lib.typ": alta, altacv

#show: altacv
#alta((basics: (name: "Jane Doe")), preferences: (bodySize: 11pt))
