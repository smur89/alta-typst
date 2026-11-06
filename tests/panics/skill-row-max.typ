// expect: skill-row() max must be a positive integer
#import "/lib.typ": altacv, skill-row

#show: altacv

= Skills
#skill-row("Go", ("Channels",), level: 2, max: 0)
