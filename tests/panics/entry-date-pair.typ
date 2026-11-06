// expect: entry() date takes one date or a `(start, end)` pair, got 3 dates
#import "/lib.typ": altacv, entry

#show: altacv

= Experience
#entry(title: "A", date: ("2020", "2021", "2022"))[]
