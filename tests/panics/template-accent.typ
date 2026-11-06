// expect: preferences.accent isn't an alta() preference inside the altacv template: use `altacv.with(theme: ..)` (the deprecated `accent` is a theme colour) after `#show: altacv.with(..)`.
#import "/lib.typ": alta, altacv

#show: altacv
#alta((basics: (name: "Jane Doe")), preferences: (accent: red))
