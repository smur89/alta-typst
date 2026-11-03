// Generic input checks behind every guided panic: "must be …" with
// the value got, unknown-key and enum checks, and their prose lists.

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

#let _check-type(name, value, allowed, expected) = _require(
  name,
  value,
  type(value) in allowed,
  expected,
)

#let _check-bool(name, value) = _check-type(name, value, (bool,), "a bool")

#let _check-enum(name, value, allowed) = _require(
  name,
  value,
  value in allowed,
  _prose-list(allowed.map(_quote)),
)
