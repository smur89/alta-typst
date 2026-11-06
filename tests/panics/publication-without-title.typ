// expect: publication() title must be a string or content, got: none
#import "/lib.typ": altacv, publication

#show: altacv

= Publications
#publication(authors: ("Jane Doe",))
