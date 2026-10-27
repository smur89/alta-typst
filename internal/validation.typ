// Shared validators — every `preferences` / `labels` shape check
// panics here, up front, so errors surface at the caller instead of as
// cryptic render-time failures. Shape checks on `cv` data fields
// (`basics.location`, `basics.image`, profile networks) stay with the
// renderer that consumes them, since they only apply when that field
// is present.

#import "dates.typ": _date_format_aliases
#import "qr.typ": _check_qr_code

// Contact-bar channels, keyed as `preferences.linkContactInfo` accepts
// them. Lives here rather than in `header.typ` (which renders them) so
// the validator can gate the dict form without a circular import —
// `header.typ` already imports this module.
#let _contact_channels = ("email", "phone", "location", "url", "profiles")

#let _quote(s) = "\"" + s + "\""

// Uniform unknown-key panic for every strict surface. `what` is the
// user-facing noun the message anchors to.
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

// Panics on the wrong override-shape (non-dictionary) up front, then
// on unknown keys so typos surface as errors instead of being silently
// absorbed.
#let _strict_merge(defaults, overrides, name) = {
  if type(overrides) != dictionary {
    panic(name + " must be a dictionary, got: " + repr(overrides))
  }
  _check_unknown_keys(overrides.keys(), defaults.keys(), name)
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

// Shared validator for string-enum preferences. Renders the allowed
// set as prose (`"a" or "b"`, `"a", "b", or "c"`) so every enum pref
// panics with the same sentence shape.
#let _check_enum(name, value, allowed) = {
  if value not in allowed {
    let options = allowed
      .map(_quote)
      .join(", ", last: if allowed.len() == 2 { " or " } else { ", or " })
    panic(name + " must be " + options + ", got: " + repr(value))
  }
}

// `section-keys` is passed in (not imported from `layout.typ`) to
// keep this module free of orchestration-layer dependencies.
#let _validate_preferences(preferences, section-keys) = {
  let column-ratio = preferences.columnRatio
  if (
    type(column-ratio) not in (int, float)
      or column-ratio <= 0
      or column-ratio > 1
  ) {
    panic("columnRatio must be a number in (0, 1], got: " + repr(column-ratio))
  }
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
  _check_enum("imagePosition", preferences.imagePosition, (
    "left",
    "right",
    "center",
  ))
  // Only meaningful when imagePosition == "center"; validated
  // unconditionally so a typo surfaces even if the caller later flips
  // the position.
  _check_enum("imageStackOrder", preferences.imageStackOrder, (
    "above",
    "below",
  ))
  _check_enum("headerTextAlign", preferences.headerTextAlign, (
    "left",
    "right",
    "center",
  ))
  // Per-channel values must be bools. Validating up front gives a
  // precise error anchored to the user's input rather than letting
  // non-bools propagate to the render-time `if` check (which would
  // panic with a generic "expected boolean" message).
  let link-contact-info = preferences.linkContactInfo
  if type(link-contact-info) == dictionary {
    _check_unknown_keys(
      link-contact-info.keys(),
      _contact_channels,
      "linkContactInfo",
    )
    for (channel, v) in link-contact-info {
      _check_bool("linkContactInfo." + channel, v)
    }
  } else if type(link-contact-info) != bool {
    panic(
      "linkContactInfo must be a bool or a dict, got: "
        + repr(link-contact-info),
    )
  }
  _check_bool("uppercaseName", preferences.uppercaseName)
  _check_bool("lastModifiedFooter", preferences.lastModifiedFooter)
  _check_bool("footerVersion", preferences.footerVersion)
  _check_bool(
    "referencesAvailableOnRequest",
    preferences.referencesAvailableOnRequest,
  )
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
    page-footer == none or page-footer == "auto" or type(page-footer) == content
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
        + "or a closure, got: "
        + repr(df),
    )
  }
  _check_qr_code(preferences.qrCode)
  // The same section catalogue that derives the column defaults also
  // gates the overrides, so adding a section stays a single-touch
  // change.
  _check_unknown_keys(
    preferences.leftColumnSections,
    section-keys,
    "leftColumnSections",
  )
  _check_unknown_keys(
    preferences.rightColumnSections,
    section-keys,
    "rightColumnSections",
  )
}

// `labels.months` is consumed by the "long" formatter and by the
// bracketed-template `[month repr:long]` / `[month repr:short]`
// tokens; validate shape and element types up front so a malformed
// override panics with a clear message rather than failing inside
// `array.at()` or string slicing at render time.
//
// `labels.publicationIcons` matching is case-insensitive, so the
// renderer lowercases the override keys. Two source keys collapsing
// onto one (e.g. `Talks` + `talks`) would silently resolve
// last-write-wins; panic so it surfaces as a configuration error —
// whether or not the CV has publications to render.
#let _validate_labels(labels) = {
  let months = labels.months
  if (
    type(months) != array
      or months.len() != 12
      or months.any(m => type(m) != str)
  ) {
    panic(
      "labels.months must be an array of 12 strings, got: " + repr(months),
    )
  }
  let icon-keys = labels.publicationIcons.keys()
  if icon-keys.map(lower).dedup().len() != icon-keys.len() {
    panic(
      "labels.publicationIcons has keys that collide after lowercasing — "
        + "matching is case-insensitive, so e.g. `Talks` and `talks` are equivalent. "
        + "Source keys: "
        + repr(icon-keys),
    )
  }
}
