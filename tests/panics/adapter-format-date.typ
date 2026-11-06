// expect: format-date() format must be "long", "short", "iso", a bracketed template (e.g. "[day]/[month]/[year]"), or a closure, got: "medium"
#import "/lib.typ": adapter

#adapter.format-date("2024-06", format: "medium")
