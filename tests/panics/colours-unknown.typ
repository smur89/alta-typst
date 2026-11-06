// expect: Unknown theme.colours key(s): "headingrule"
#import "/lib.typ": altacv

#show: altacv.with(theme: (colours: (headingrule: red)))
