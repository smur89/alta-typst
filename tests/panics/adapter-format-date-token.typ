// expect: Unknown format-date() format token: [hour]
#import "/lib.typ": adapter

#adapter.format-date("2024-06", format: "[hour] [year]")
