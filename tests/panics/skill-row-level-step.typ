// expect: skill-row() level must be a multiple of 0.5, got: 2.3
#import "/lib.typ": altacv, skill-row

#show: altacv

= Skills
#skill-row("Go", ("Channels",), level: 2.3)
