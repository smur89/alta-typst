// expect: cv-header() photo-shape must be "circle", "rounded", or "square"
#import "/lib.typ": altacv, cv-header

#show: altacv

#cv-header(name: "Jane Doe", photo-shape: "oval")
