// expect: tag() takes `category:`; `label:` is its deprecated name, so pass only `category:`
#import "/lib.typ": tag

#tag(category: true, label: true)[Go]
