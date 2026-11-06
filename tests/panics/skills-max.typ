// expect: skills() max must be a positive integer
#import "/lib.typ": altacv, skills

#show: altacv

= Skills
#skills("Go", ("Channels",), level: 2, max: 0)
