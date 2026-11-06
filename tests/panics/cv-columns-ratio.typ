// expect: cv-columns() ratio must be a number in (0, 1]
#import "/lib.typ": altacv, cv-columns

#show: altacv

#cv-columns([Left], [Right], ratio: 0)
