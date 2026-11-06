// expect: basics-contacts() maps-provider must be `none` or a URL template string containing `{q}`, got: "https://maps"
#import "/lib.typ": adapter

#adapter.basics-contacts((location: "Cork"), maps-provider: "https://maps")
