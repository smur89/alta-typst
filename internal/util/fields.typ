// Dict readers: a field's value, or `none` when it's absent. Reading
// the CV is for sections and `data/`; components don't import this
// module, but get values through slots (ARCHITECTURE.md).

#import "values.typ": _present, _present_str

// A field's value, or `none` when it's absent in any of those forms.
#let _field(obj, key) = {
  let v = obj.at(key, default: none)
  if _present(v) { v }
}

#let _dict_or_empty(v) = if type(v) == dictionary { v } else { (:) }

#let _string_at(obj, key) = {
  let v = obj.at(key, default: none)
  if _present_str(v) { v }
}

