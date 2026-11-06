// expect: preferences.paper isn't an alta() preference inside the altacv template
#import "/lib.typ": adapter

#adapter.preferences(overrides: (paper: "a5"))
