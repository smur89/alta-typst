// Generic value helpers: presence checks, field reads, joins, label
// templates and URL encoding. No knowledge of the CV's shape
// (`data/cv.typ`) and no styling (`primitives.typ`). `_present` is the
// canonical "is this field set" check.

// The three ways a field can be effectively absent.
#let _present(v) = v != none and v != "" and v != []

// A field's value, or `none` when it's absent in any of those forms.
#let _field(obj, key) = {
  let v = obj.at(key, default: none)
  if _present(v) { v }
}

// The non-`none` parts joined by `sep`; `none` when no part is left,
// so callers can skip the whole line.
#let _join_present(parts, sep) = parts.filter(p => p != none).join(sep)

#let _dict_or_empty(v) = if type(v) == dictionary { v } else { (:) }

// Stricter than `_present` where a plain string is required (PDF
// metadata, grouping keys).
#let _present_str(v) = type(v) == str and v != ""

#let _string_at(obj, key) = {
  let v = obj.at(key, default: none)
  if _present_str(v) { v }
}

// `{key}` label templates. One regex pass, so a substituted value
// containing `{…}` (e.g. a name) is never re-expanded. Unknown
// placeholders are rejected by `_validate_labels`.
#let _placeholder_re = regex("\{(\w+)\}")
#let _fill_template(template, values) = template.replace(
  _placeholder_re,
  m => values.at(m.captures.first()),
)

// Per RFC 3986. Iterates UTF-8 bytes (not codepoints), so non-Latin
// locations like "Zürich" or "京都" round-trip through the maps URL.
#let _url_encode(s) = {
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
