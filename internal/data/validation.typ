// Up-front shape checks for `preferences`, `labels` and each CV
// section's entry array, so errors name the caller's input rather than
// surfacing mid-render. Checks on individual `cv` fields stay with the
// code that consumes them, as they apply only when the field is set.

#import "../design/icon-set.typ": _icon-glyphs
#import "../util/checks.typ": (
  _check-bool, _check-enum, _check-type, _check-unknown-keys, _prose-list,
  _require,
)
#import "../util/dates.typ": _date-format-aliases
#import "../util/values.typ": _placeholder-re

// Called from `_validate-preferences`, so a typo (`qrCode: true`)
// fails up front rather than inside `qrcode(...)` at render time.
#let _check-qr-code(value) = {
  if value == none or value == auto { return }
  if type(value) != str {
    panic(
      "qrCode must be `none`, `auto`, or a URL string, got: " + repr(value),
    )
  }
  if value == "" {
    panic("qrCode must be a non-empty string when not `none` / `auto`.")
  }
}

// `linkContactInfo` channels. Here rather than in `sections/header.typ`,
// which reads them, to avoid a cycle: it imports this module.
#let _contact-channels = ("email", "phone", "location", "url", "profiles")

// Unknown keys panic rather than being silently absorbed. The keys
// named in `tables` (`labels.publicationTypes`) hold dictionaries that
// merge entry by entry, so a partial override keeps the rest; any
// other key is replaced whole, dictionary or not (`margin`).
#let _strict-merge(defaults, overrides, name, tables: ()) = {
  if type(overrides) != dictionary {
    panic(name + " must be a dictionary, got: " + repr(overrides))
  }
  _check-unknown-keys(overrides.keys(), defaults.keys(), name)
  let merge-key(key, value) = {
    let default = defaults.at(key)
    if key in tables {
      _require(
        name + "." + key,
        value,
        type(value) == dictionary,
        "a dictionary",
      )
      default + value
    } else { value }
  }
  defaults + overrides.pairs().map(((k, v)) => (k, merge-key(k, v))).to-dict()
}

// Every spacing token multiplies `bodySize`, so it must be an absolute
// length: `1em` would resolve against itself, and a bare number reaches
// `set text(...)` as a stray positional.
#let _is-body-size(v) = type(v) == length and v.em == 0 and v.abs > 0pt

#let _is-margin-side(v) = type(v) in (length, ratio, relative) or v == auto
#let _is-margin(v) = if type(v) == dictionary {
  v.values().all(_is-margin-side)
} else { _is-margin-side(v) }

// A family name, or a fallback list of names / `(name, covers)` dicts.
#let _is-font-list(v) = (
  type(v) == array and v.len() > 0 and v.all(f => type(f) in (str, dictionary))
)
#let _is-font(v) = type(v) == str or _is-font-list(v)

// `section-keys` is passed in, not imported: `registry.typ` imports this
// module. `groupCertificates` is ignored, so it isn't checked.
#let _validate-preferences(preferences, section-keys) = {
  // Only a colour supports `lighten` / `darken`; a palette name string
  // is the common slip.
  _check-type(
    "accent",
    preferences.accent,
    (color,),
    "a colour (e.g. palettes.navy or rgb(\"#1A3A6C\"))",
  )
  _require(
    "bodySize",
    preferences.bodySize,
    _is-body-size(preferences.bodySize),
    "a positive absolute length (e.g. 10pt)",
  )
  _check-type(
    "imageSize",
    preferences.imageSize,
    (length, ratio, relative),
    "a length (e.g. 6em)",
  )
  _check-type("paper", preferences.paper, (str,), "a paper name (e.g. \"a4\")")
  _require(
    "margin",
    preferences.margin,
    _is-margin(preferences.margin),
    "a length, `auto`, or a dict of them (e.g. (x: 1cm, y: 1.5cm))",
  )
  _require(
    "font",
    preferences.font,
    _is-font(preferences.font),
    "a font family name or a non-empty array of them",
  )
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
  _check-enum("imagePosition", preferences.imagePosition, (
    "left",
    "right",
    "center",
  ))
  // Checked even when unused, so a typo surfaces before it matters.
  _check-enum("imageStackOrder", preferences.imageStackOrder, (
    "above",
    "below",
  ))
  _check-enum("headerTextAlign", preferences.headerTextAlign, (
    "left",
    "right",
    "center",
  ))
  let link-contact-info = preferences.linkContactInfo
  if type(link-contact-info) == dictionary {
    _check-unknown-keys(
      link-contact-info.keys(),
      _contact-channels,
      "linkContactInfo",
    )
    for (channel, v) in link-contact-info {
      _check-bool("linkContactInfo." + channel, v)
    }
  } else if type(link-contact-info) != bool {
    panic(
      "linkContactInfo must be a bool or a dict, got: "
        + repr(link-contact-info),
    )
  }
  _check-bool("uppercaseName", preferences.uppercaseName)
  _check-bool("showPronouns", preferences.showPronouns)
  _check-bool("lastModifiedFooter", preferences.lastModifiedFooter)
  _check-bool("footerVersion", preferences.footerVersion)
  _check-bool(
    "referencesAvailableOnRequest",
    preferences.referencesAvailableOnRequest,
  )
  let max-rating = preferences.maxRating
  if type(max-rating) != int or max-rating < 1 {
    panic("maxRating must be a positive integer, got: " + repr(max-rating))
  }
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
    // Bracketed templates are left to `_apply-date-template`.
    if "[" not in df and df != "iso" and df not in _date-format-aliases {
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
  _check-qr-code(preferences.qrCode)
  _check-unknown-keys(
    preferences.leftColumnSections,
    section-keys,
    "leftColumnSections",
  )
  _check-unknown-keys(
    preferences.rightColumnSections,
    section-keys,
    "rightColumnSections",
  )
}

// A `{key}` template label. A missing or misspelt (`{totl}`)
// placeholder would otherwise render literally — for the title,
// silently into PDF metadata.
#let _validate-template-label(labels, key, required, optional) = {
  let template = labels.at(key)
  if type(template) != str {
    panic("labels." + key + " must be a string, got: " + repr(template))
  }
  let allowed = required + optional
  let found = template.matches(_placeholder-re).map(m => m.captures.first())
  let unknown = found.filter(p => p not in allowed)
  if unknown.len() > 0 {
    panic(
      "labels."
        + key
        + " has unknown placeholder(s) "
        + repr(unknown.map(p => "{" + p + "}"))
        + "; allowed: "
        + repr(allowed.map(p => "{" + p + "}"))
        + ". Got: "
        + repr(template),
    )
  }
  let missing = required.filter(p => p not in found)
  if missing.len() > 0 {
    panic(
      "labels."
        + key
        + " must contain "
        + missing.map(p => "{" + p + "}").join(", ")
        + ". Got: "
        + repr(template),
    )
  }
}

// Typst accepts any case; requiring lowercase keeps label files
// canonical and catches a language *name* ("Irish") up front.
#let _lang-re = regex("^[a-z]{2,3}$")

// A dict where a list belongs fails here, not deep in a renderer.
// Returns `entries`.
#let _check-section-entries(key, entries, item-types) = {
  _check-type(key, entries, (array,), "an array")
  let bad = entries.find(e => type(e) not in item-types)
  _require(
    key + " entries",
    bad,
    bad == none,
    _prose-list(item-types.map(repr)),
  )
  entries
}

// Checked up front, as `icon()` would fail on a bare missing key.
// `name` is the table's full path, for the message.
#let _check-icon-names(table, name) = for (code, icon-name) in table {
  _check-enum(name + "." + code, icon-name, _icon-glyphs.keys())
}

#let _validate-labels(labels) = {
  // Deprecated (#239), and merged into the preference's icons by
  // `_canonical-preferences`, which needs a dictionary.
  _check-type(
    "labels.publicationIcons",
    labels.publicationIcons,
    (dictionary,),
    "a dictionary",
  )
  let lang = labels.lang
  if type(lang) != str or lang.match(_lang-re) == none {
    panic(
      "labels.lang must be a lowercase ISO 639 code (2–3 letters, e.g. \"de\"), got: "
        + repr(lang),
    )
  }
  _validate-template-label(labels, "pageNumber", ("current",), ("total",))
  _validate-template-label(labels, "documentTitle", ("name",), ())
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
}
