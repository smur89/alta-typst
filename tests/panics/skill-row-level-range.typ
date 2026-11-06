// expect: skill-row() level must be between 0 and 5, got: 6
#import "/lib.typ": altacv, skill-row

#show: altacv

= Skills
#skill-row("Go", ("Channels",), level: 6)
