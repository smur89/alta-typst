// Generic input checks behind every guided panic: "must be …" with
// the value got, the rules that drive it, unknown-key and enum checks,
// and their prose lists.

#import "values.typ": _round-half

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
#let _positive-int-rule = (
  v => type(v) == int and v >= 1,
  "a positive integer",
)
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

// A rating on a `max`-dot scale: a number from 0 to `max`, in halves.
// Half dots are the only fraction drawable; rejecting others stops
// `3.1` and `3.9` silently rounding alike.
#let _check-rating(name, value, max) = {
  _check-type(name, value, (int, float), "a number")
  _require(
    name,
    value,
    value >= 0 and value <= max,
    "between 0 and " + str(max),
  )
  _require(name, value, _round-half(value) == value, "a multiple of 0.5")
}
