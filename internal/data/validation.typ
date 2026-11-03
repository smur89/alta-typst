// Up-front checks for `preferences` and `labels`, so errors name the
// caller's input rather than surfacing mid-render. The CV's are in
// `cv-checks.typ`.

#import "../design/icon-set.typ": _icon-glyphs
#import "../util/checks.typ": (
  _bool-rule, _check, _check-rules, _check-type, _check-unknown-keys,
  _enum-rule, _positive-int-rule, _type-rule,
)
#import "../util/dates.typ": _check-date-template, _date-format-aliases
#import "../util/values.typ": _placeholder-re, _present-str

// `linkContactInfo` channels and `headerTextAlign` values. In `data/`,
// as `sections/header.typ` reads them too and `data/` may not import
// sections.
#let _contact-channels = ("email", "phone", "location", "url", "profiles")
#let _text-aligns = (left: left, right: right, center: center)

// Unknown keys panic rather than being silently absorbed. The keys
// named in `tables` (`labels.publicationTypes`) hold dictionaries that
// merge entry by entry, so a partial override keeps the rest; any
// other key is replaced whole, dictionary or not (`margin`).
#let _strict-merge(defaults, overrides, name, tables: ()) = {
  _check-type(name, overrides, (dictionary,), "a dictionary")
  _check-unknown-keys(overrides.keys(), defaults.keys(), name)
  let merge-key(key, value) = {
    let default = defaults.at(key)
    if key in tables {
      _check-type(name + "." + key, value, (dictionary,), "a dictionary")
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

// A named formatter, a bracketed template (its tokens are left to
// `_apply-date-template`), or a closure.
#let _is-date-format(v) = (
  type(v) == function
    or (
      type(v) == str and ("[" in v or v == "iso" or v in _date-format-aliases)
    )
)

// `name` is the table's full path, for the message.
#let _icon-name-rule = _enum-rule(_icon-glyphs.keys())
#let _check-icon-names(table, name) = for (code, icon-name) in table {
  _check(name + "." + code, icon-name, _icon-name-rule)
}

// The single-value preferences, in `_default-preferences`' order. The
// rest are checked in `_validate-preferences`, or for the icon tables
// in `_merge-options`; `groupCertificates` is
// ignored, so it isn't checked.
#let _preference-rules = (
  font: (_is-font, "a font family name or a non-empty array of them"),
  bodySize: (_is-body-size, "a positive absolute length (e.g. 10pt)"),
  // Only a colour supports `lighten` / `darken`; a palette name string
  // is the common slip.
  accent: _type-rule(
    (color,),
    "a colour (e.g. palettes.navy or rgb(\"#1A3A6C\"))",
  ),
  uppercaseName: _bool-rule,
  showPronouns: _bool-rule,
  headerTextAlign: _enum-rule(_text-aligns.keys()),
  imageSize: _type-rule((length, ratio, relative), "a length (e.g. 6em)"),
  imagePosition: _enum-rule(("left", "right", "center")),
  // Checked even when unused, so a typo surfaces before it matters.
  imageStackOrder: _enum-rule(("above", "below")),
  // A typo (`qrCode: true`) fails here, not inside `qrcode(...)`.
  qrCode: (
    v => v == none or v == auto or _present-str(v),
    "`none`, `auto`, or a non-empty URL string",
  ),
  paper: _type-rule((str,), "a paper name (e.g. \"a4\")"),
  margin: (
    _is-margin,
    "a length, `auto`, or a dict of them (e.g. (x: 1cm, y: 1.5cm))",
  ),
  columnRatio: (
    v => type(v) in (int, float) and v > 0 and v <= 1,
    "a number in (0, 1]",
  ),
  pageFooter: (
    v => v == none or v == auto or type(v) == content,
    "`none`, `auto`, or a content value",
  ),
  lastModifiedFooter: _bool-rule,
  footerVersion: _bool-rule,
  dateFormat: (
    _is-date-format,
    "\"long\", \"short\", \"iso\", a bracketed template "
      + "(e.g. \"[day]/[month]/[year]\"), or a closure",
  ),
  mapsProvider: (
    v => v == none or (type(v) == str and "{q}" in v),
    "`none` or a URL template string containing `{q}`",
  ),
  maxRating: _positive-int-rule,
  referencesAvailableOnRequest: _bool-rule,
)

// `section-keys` is passed in, not imported: `data/sections.typ`
// imports this module, through `canonical.typ`.
#let _validate-preferences(prefs, section-keys) = {
  _check-rules(prefs, _preference-rules)
  let link-contact-info = prefs.linkContactInfo
  _check-type(
    "linkContactInfo",
    link-contact-info,
    (bool, dictionary),
    "a bool or a dict",
  )
  if type(link-contact-info) == dictionary {
    _check-unknown-keys(
      link-contact-info.keys(),
      _contact-channels,
      "linkContactInfo",
    )
    for (channel, v) in link-contact-info {
      _check("linkContactInfo." + channel, v, _bool-rule)
    }
  }
  if type(prefs.dateFormat) == str {
    _check-date-template(prefs.dateFormat, "dateFormat")
  }
  for key in ("leftColumnSections", "rightColumnSections") {
    _check-unknown-keys(prefs.at(key), section-keys, key)
  }
}

// A `{key}` template label. A missing or misspelt (`{totl}`)
// placeholder would otherwise render literally — for the title,
// silently into PDF metadata.
#let _validate-template-label(labels, key, required, optional) = {
  let template = labels.at(key)
  _check-type("labels." + key, template, (str,), "a string")
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

#let _lang-re = regex("^[a-z]{2,3}$")

#let _label-rules = (
  // Deprecated (#239), and merged into the preference's icons by
  // `_canonical-preferences`, which needs a dictionary.
  publicationIcons: _type-rule((dictionary,), "a dictionary"),
  // Typst accepts any case; requiring lowercase keeps label files
  // canonical and catches a language *name* ("Irish") up front.
  lang: (
    v => type(v) == str and v.match(_lang-re) != none,
    "a lowercase ISO 639 code (2–3 letters, e.g. \"de\")",
  ),
  months: (
    v => type(v) == array and v.len() == 12 and v.all(m => type(m) == str),
    "an array of 12 strings",
  ),
)

#let _validate-labels(labels) = {
  _check-rules(labels, _label-rules, prefix: "labels.")
  _validate-template-label(labels, "pageNumber", ("current",), ("total",))
  _validate-template-label(labels, "documentTitle", ("name",), ())
}
