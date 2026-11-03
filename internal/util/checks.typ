// Generic input checks behind every guided panic: "must be …" with
// the value got, the rules that drive it, unknown-key and enum checks,
// and their prose lists.

#let _quote(s) = "\"" + s + "\""

// `"a" or "b"`, `"a", "b", or "c"`.
#let _prose-list(items) = items.join(
  ", ",
  last: if items.len() == 2 { " or " } else { ", or " },
)

// The shared "must be …" panic.
#let _require(name, value, ok, expected) = {
  if not ok { panic(name + " must be " + expected + ", got: " + repr(value)) }
}

#let _check-unknown-keys(candidates, allowed, what) = {
  let unknown = candidates.filter(k => k not in allowed)
  if unknown.len() > 0 {
    panic(
      "Unknown "
        + what
        + " key(s): "
        + unknown.map(_quote).join(", ")
        + ". Supported: "
        + allowed.map(_quote).join(", "),
    )
  }
}

// Rules for `_check` and `_check-rules`: `(ok, expected)`, where `ok`
// tests the value and `expected` completes "<name> must be …".
#let _type-rule(types, expected) = (v => type(v) in types, expected)
#let _bool-rule = _type-rule((bool,), "a bool")
#let _enum-rule(allowed) = (
  v => v in allowed,
  _prose-list(allowed.map(_quote)),
)

#let _check(name, value, (ok, expected)) = _require(
  name,
  value,
  ok(value),
  expected,
)

// Each `key: rule` against `values.at(key)`, named `prefix + key`.
#let _check-rules(values, rules, prefix: "") = for (key, rule) in rules {
  _check(prefix + key, values.at(key), rule)
}

#let _check-type(name, value, allowed, expected) = _check(
  name,
  value,
  _type-rule(allowed, expected),
)

#let _check-bool(name, value) = _check(name, value, _bool-rule)

#let _check-enum(name, value, allowed) = _check(
  name,
  value,
  _enum-rule(allowed),
)
