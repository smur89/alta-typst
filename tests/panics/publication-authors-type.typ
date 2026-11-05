// expect: publication() authors must be an array of strings or content, got: "Jane Doe"
#import "/lib.typ": altacv, publication

#show: altacv

= Publications

#publication(title: "Ledgers at Scale", authors: "Jane Doe")[]
