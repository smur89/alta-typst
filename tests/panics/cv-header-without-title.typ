// expect: cv-header() shows the document's title as your name: `#set document(title: "Jane Doe")` first, or pass `name:`
#import "/lib.typ": altacv, cv-header

#show: altacv

#cv-header(tagline: "Engineer")
