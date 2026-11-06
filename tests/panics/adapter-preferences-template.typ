// expect: preferences.paper isn't an alta() preference inside the altacv template: use `set page(paper: ..)` after `#show: altacv.with(..)`.
#import "/lib.typ": adapter

#adapter.preferences(overrides: (paper: "a5"))
