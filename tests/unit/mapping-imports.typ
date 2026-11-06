// The JSON Resume mapping (`adapter/json-resume.typ`) is written to be
// copied, its imports replaced by one `@preview/altacv` import, so it
// may use only what `lib.typ` exports: every name its `#import` lines
// bring in must be a public one.

#import "/lib.typ"
// It compiles, too.
#import "/adapter/json-resume.typ": resume

// Each `#import "..."` line's names: an `as` alias, or the list after
// the colon, on one line or in typstyle's parenthesised, multi-line
// form.
#let imported = (
  read("/adapter/json-resume.typ")
    .matches(
      regex(
        "(?m)^#import\\s+\"[^\"]*\"\\s*(?:as\\s+([\\w-]+)|:\\s*(\\([^)]*\\)|[^\\n]+))",
      ),
    )
    .map(m => if m.captures.at(0) != none { (m.captures.at(0),) } else {
      m
        .captures
        .at(1)
        .trim(regex("[()\\s]+"))
        .split(",")
        .map(name => name.trim())
        .filter(name => name != "")
    })
    .flatten()
)

#assert(imported.len() > 0, message: "no imports found in the mapping")
#for name in imported {
  assert(
    name in dictionary(lib),
    message: "adapter/json-resume.typ imports `"
      + name
      + "`, which lib.typ doesn't export",
  )
}
