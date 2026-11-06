// expect: Unknown publication() citation key(s): "page"
#import "/lib.typ": altacv, publication

#show: altacv

= Publications
#publication(title: "Paper", citation: (volume: "12", page: "4"))[]
