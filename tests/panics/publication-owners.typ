// expect: publication() owners must be auto or an array of strings
#import "/lib.typ": altacv, publication

#show: altacv

= Publications
#publication(title: "Paper", authors: ("Jane Doe",), owners: "Jane Doe")[]
