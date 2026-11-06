// expect: skill-row() max must be a positive integer, got: 0
#import "/lib.typ": altacv, skill-row

#show: altacv

= Skills
#skill-row("Go", ("Channels",), level: 2, max: 0)
