// expect: skills() level must be between 0 and 5
#import "/lib.typ": altacv, skills

#show: altacv

= Skills
#skills("Go", ("Channels",), level: 6)
