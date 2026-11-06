// expect: skill-row() level must be between 0 and 5
#import "/lib.typ": altacv, skill-row

#show: altacv

= Skills
#skill-row("Go", ("Channels",), level: 6)
