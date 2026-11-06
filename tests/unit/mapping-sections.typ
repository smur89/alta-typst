// The JSON Resume mapping draws every section `alta()` knows, and no
// other: its `sections` are `_section-specs`' keys, in their order, so
// any key a column preference accepts has a function to draw it.

#import "/adapter/json-resume.typ": sections
#import "/internal/data/sections.typ": _section-specs

#assert.eq(sections.keys(), _section-specs.keys())
