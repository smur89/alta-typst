// Generic value helpers: presence checks, joins, grouping, rounding,
// label templates and URL encoding. Safe for every layer, components
// included; the dict readers are in `fields.typ`. `_present` is the
// canonical "is this field set" check.

// The three ways a field can be effectively absent.
#let _present(v) = v != none and v != "" and v != []

// The non-`none` parts joined by `sep`; `none` when no part is left,
// so callers can skip the whole line.
#let _join-present(parts, sep) = parts.filter(p => p != none).join(sep)

// Stricter than `_present` where a plain string is required (PDF
// metadata, grouping keys).
#let _present-str(v) = type(v) == str and v != ""

// `{key}` label templates. One regex pass, so a substituted value
// containing `{…}` (e.g. a name) is never re-expanded. Unknown
// placeholders are rejected by `_validate-labels`.
#let _placeholder-re = regex("\{(\w+)\}")

#let _fill-template(template, values) = template.replace(
  _placeholder-re,
  m => values.at(m.captures.first()),
)

// Per RFC 3986. Iterates UTF-8 bytes (not codepoints), so non-Latin
// locations like "Zürich" or "京都" round-trip through the maps URL.
#let _url-encode(s) = {
  let unreserved = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
  let hex = "0123456789ABCDEF"
  let out = ""
  for b in array(bytes(s)) {
    if b < 128 and str.from-unicode(b) in unreserved {
      out += str.from-unicode(b)
    } else {
      out += "%" + hex.at(int(b / 16)) + hex.at(int(calc.rem(b, 16)))
    }
  }
  out
}

// First-occurrence order (Typst dicts keep insertion order). Keys
// must be strings.
#let _group-by(items, key-of) = items.fold((:), (acc, item) => {
  let key = key-of(item)
  acc + ((key): acc.at(key, default: ()) + (item,))
})

#let _round-half(x) = calc.round(x * 2) / 2
