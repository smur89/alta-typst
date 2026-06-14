// Shared validators. `_strict_merge` is the typo-catcher used to
// merge user overrides over the built-in defaults dicts; `_check_bool`
// is the uniform bool-validation helper for individual preference
// fields; `_validate_shared_preferences` runs the cross-entrypoint
// checks every public entrypoint (`alta`, `cover-letter`, …) needs.
// All panic on misuse so errors surface at the caller rather than as
// cryptic render-time failures.

#import "dates.typ": _date_format_aliases

// Panics on the wrong override-shape (non-dictionary) up front, then
// on unknown keys so typos surface as errors instead of being silently
// absorbed.
#let _strict_merge(defaults, overrides, name) = {
  if type(overrides) != dictionary {
    panic(name + " must be a dictionary, got: " + repr(overrides))
  }
  let unknown = overrides.keys().filter(k => k not in defaults)
  if unknown.len() > 0 {
    panic(
      "Unknown " + name + " key(s): " + unknown.join(", ")
        + ". Valid keys: " + defaults.keys().join(", "),
    )
  }
  defaults + overrides
}

// Shared validator for bool-typed preferences — keeps panic messages
// uniform and avoids the same five-line `if type(...) != bool` block
// across every new pref.
#let _check_bool(name, value) = {
  if type(value) != bool {
    panic(name + " must be a bool, got: " + repr(value))
  }
}

// Validates the subset of `preferences` shared by every public
// entrypoint (`alta`, `cover-letter`, …). Per-entrypoint checks
// (`columnRatio` is `alta`-only because cover-letter is single-column)
// stay at the call site. `labels` is taken so the `months` shape
// check — which the date formatter depends on — can run here too.
#let _validate_shared_preferences(preferences, labels) = {
  let mp = preferences.mapsProvider
  if mp != none {
    if type(mp) != str {
      panic(
        "mapsProvider must be a URL template string (containing `{q}`) or `none`, got: "
          + repr(mp),
      )
    }
    if "{q}" not in mp {
      panic(
        "mapsProvider URL template must contain the `{q}` placeholder, got: "
          + repr(mp),
      )
    }
  }
  _check_bool("uppercaseName", preferences.uppercaseName)
  _check_bool("lastModifiedFooter", preferences.lastModifiedFooter)
  let max-rating = preferences.maxRating
  if type(max-rating) != int or max-rating < 1 {
    panic("maxRating must be a positive integer, got: " + repr(max-rating))
  }
  // `pageFooter` accepts `none`, the string `"auto"`, or any content
  // value. Any other type — bools, dicts, numbers — panics so a typo
  // like `pageFooter: true` surfaces at the call site rather than
  // falling through to a render-time failure inside `set page(...)`.
  let page-footer = preferences.pageFooter
  let footer-ok = (
    page-footer == none
      or page-footer == "auto"
      or type(page-footer) == content
  )
  if not footer-ok {
    panic(
      "pageFooter must be `none`, the string \"auto\", or a content value, got: "
        + repr(page-footer),
    )
  }
  let df = preferences.dateFormat
  if type(df) == str {
    // Bracketed templates (`[year]`, `[month repr:long]`, …) defer to
    // `_apply_date_template`; bare strings must be one of the named
    // formatters or the literal `"iso"` passthrough.
    if "[" not in df and df != "iso" and df not in _date_format_aliases {
      panic(
        "dateFormat must be \"long\", \"short\", \"iso\", a bracketed template "
          + "(e.g. \"[day]/[month]/[year]\"), or a closure; got: "
          + repr(df),
      )
    }
  } else if type(df) != function {
    panic(
      "dateFormat must be a string (named formatter or bracketed template) "
        + "or a closure, got: " + repr(df),
    )
  }
  // `labels.months` is consumed by the "long" formatter and by the
  // bracketed-template `[month repr:long]` / `[month repr:short]`
  // tokens; validate shape and element types up front so a malformed
  // override panics with a clear message rather than failing inside
  // `array.at()` or string slicing at render time.
  let months = labels.months
  if type(months) != array or months.len() != 12 or months.any(m => type(m) != str) {
    panic(
      "labels.months must be an array of 12 strings, got: " + repr(months),
    )
  }
}
