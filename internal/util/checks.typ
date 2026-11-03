// Generic input checks behind every guided panic: "must be …" with
// the value got, unknown-key and enum checks, and their prose lists.

#let _quote(s) = "\"" + s + "\""

// `"a" or "b"`, `"a", "b", or "c"`.
#let _prose_list(items) = items.join(
  ", ",
  last: if items.len() == 2 { " or " } else { ", or " },
)

// The shared "must be …" panic.
#let _require(name, value, ok, expected) = {
  if not ok { panic(name + " must be " + expected + ", got: " + repr(value)) }
}

#let _check_unknown_keys(candidates, allowed, what) = {
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

#let _check_type(name, value, allowed, expected) = _require(
  name,
  value,
  type(value) in allowed,
  expected,
)

#let _check_bool(name, value) = _check_type(name, value, (bool,), "a bool")

#let _check_enum(name, value, allowed) = _require(
  name,
  value,
  value in allowed,
  _prose_list(allowed.map(_quote)),
)
