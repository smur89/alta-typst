// Up-front checks for `preferences` and `labels`, so errors name the
// caller's input rather than surfacing mid-render. The CV's are in
// `cv-checks.typ`.

#import "../design/icon-set.typ": _fa-glyphs, _icon-glyphs
#import "../design/theme.typ": (
  _default-theme, _token-prefs, _tokens, _treatment-names,
)
#import "../util/checks.typ": (
  _bool-rule, _check, _check-keys, _check-rules, _check-type,
  _check-unknown-keys, _enum-rule, _list-rule, _positive-int-rule, _type-rule,
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
  _check-keys(name, overrides, defaults.keys())
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

// The icon tables' value rules: icon-set keys, except `profileIcons`,
// which takes raw FontAwesome glyph names, as it draws networks the
// icon set doesn't ship. Too many to list, so its message points at
// the catalogue instead.
#let _icon-name-rule = _enum-rule(_icon-glyphs.keys())
#let _icon-table-rules = (
  profileIcons: (
    v => type(v) == str and v in _fa-glyphs,
    "a FontAwesome icon name (https://fontawesome.com/search, e.g. \"kaggle\")",
  ),
)

// `table` is the caller's `preferences.<key>`; each value is checked
// against that key's rule and named by its full path, for the message.
#let _check-icon-names(table, key) = for (code, icon-name) in table {
  _check(
    "preferences." + key + "." + code,
    icon-name,
    _icon-table-rules.at(key, default: _icon-name-rule),
  )
}

// The single-value preferences, in `_default-preferences`' order. The
// rest are checked in `_validate-preferences` (`font` and `colours`
// with the theme's tokens), or for the icon tables in
// `_merge-options`; `groupCertificates` and `showPronouns` are
// ignored, so they aren't checked.
#let _preference-rules = (
  bodySize: (_is-body-size, "a positive absolute length (e.g. 10pt)"),
  uppercaseName: _bool-rule,
  headerTextAlign: _enum-rule(_text-aligns.keys()),
  imageSize: _type-rule((length, ratio, relative), "a length (e.g. 6em)"),
  imageShape: _enum-rule(_default-theme.header.portrait-radius.keys()),
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
  justify: _bool-rule,
  dateFormat: (
    _is-date-format,
    "\"long\", \"short\", \"iso\", a bracketed template "
      + "(e.g. \"[day]/[month]/[year]\"), or a closure",
  ),
  printFullUrls: _bool-rule,
  mapsProvider: (
    v => v == none or (type(v) == str and "{q}" in v),
    "`none` or a URL template string containing `{q}`",
  ),
  maxRating: _positive-int-rule,
  skillLevelDisplay: (
    v => v == auto or v in ("rating", "text"),
    "`auto`, \"rating\" or \"text\"",
  ),
  ownerNames: _list-rule((str,), "an array of strings"),
  referencesAvailableOnRequest: _bool-rule,
)

// Only a colour supports `lighten` / `darken`; a palette name string
// is the common slip.
#let _colour-rule = _type-rule(
  (color,),
  "a colour (e.g. rgb(\"#1A3A6C\"))",
)

#let _font-rule = (_is-font, "a font family name or a non-empty array of them")
// Typst's weight names, or a number from 100 to 900, as `text` takes.
#let _weight-names = (
  "thin",
  "extralight",
  "light",
  "regular",
  "medium",
  "semibold",
  "bold",
  "extrabold",
  "black",
)
#let _weight-rule = (
  v => v in _weight-names or (type(v) == int and v >= 100 and v <= 900),
  "a font weight (\"regular\", \"bold\", … or 100 to 900)",
)
// The scales: sizes, leading and strokes must be positive; a space may
// be zero.
#let _positive-number-rule = (
  v => type(v) in (int, float) and v > 0,
  "a positive number",
)
#let _space-rule = (
  v => type(v) in (int, float) and v >= 0,
  "a number, zero or more",
)
// Joined into content, so a separator may be content or a symbol too
// (`[ | ]`, `sym.bullet`).
#let _separator-rule = _type-rule(
  (str, content, symbol),
  "a string, content or a symbol",
)

// Tokens whose rule isn't their default's kind, by the first segment
// of their path (`treatment`), else by its last (`weight`).
#let _token-rules = (
  font: _font-rule,
  treatment: _enum-rule(_treatment-names),
  separator: _separator-rule,
  font-weight: _weight-rule,
  weight: _weight-rule,
  space: _space-rule,
)

// A token of `default`'s kind: a colour, a positive number, strings as
// many as its own (the citation's issue brackets), or a string.
#let _kind-rule(default) = if type(default) == color { _colour-rule } else if (
  type(default) in (int, float)
) { _positive-number-rule } else if type(default) == array {
  let (is-strings, _) = _list-rule((str,), "")
  (
    v => is-strings(v) and v.len() == default.len(),
    "an array of " + str(default.len()) + " strings",
  )
} else { _type-rule((str,), "a string") }

#let _token-rule(path, default) = _token-rules.at(
  path.first(),
  default: _token-rules.at(path.last(), default: _kind-rule(default)),
)

// `value` as overrides of `defaults` (some of `_tokens`, at `path`), any
// subset at any depth: no key `defaults` lacks, a dictionary where it
// has one, and each value by `_token-rule`. `prefix` leads the path in
// messages (`theme.type.title.size`).
#let _check-tokens(value, defaults, prefix, path: ()) = {
  let name(at) = {
    let parts = ((prefix,) + at).filter(s => s != "")
    if parts == () { "preferences" } else { parts.join(".") }
  }
  _check-keys(name(path), value, defaults.keys())
  for (key, v) in value {
    let at = path + (key,)
    let default = defaults.at(key)
    if type(default) == dictionary {
      _check-tokens(v, default, prefix, path: at)
    } else { _check(name(at), v, _token-rule(at, default)) }
  }
}

// A theme is `_tokens` overrides, any of them, and so are the
// preferences that override it (`_token-prefs`: `font`, `colours`).
#let _validate-theme(prefs) = {
  _check-type(
    "theme",
    prefs.theme,
    (dictionary,),
    "a theme (e.g. themes.altacv)",
  )
  _check-tokens(prefs.theme, _tokens, "theme")
  _check-tokens(_token-prefs(prefs), _tokens, "")
}

// `section-keys` is passed in, not imported: `data/sections.typ`
// imports this module, through `canonical.typ`.
#let _validate-preferences(prefs, section-keys) = {
  _check-rules(prefs, _preference-rules)
  _validate-theme(prefs)
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
