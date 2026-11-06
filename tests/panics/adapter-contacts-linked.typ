// expect: basics-contacts() linked must be a bool or a dict, got: "yes"
#import "/lib.typ": adapter

#adapter.basics-contacts((email: "j@d.ie"), linked: "yes")
