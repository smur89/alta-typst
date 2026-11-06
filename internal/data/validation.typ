// Up-front checks for `preferences` and `labels`, so errors name the
// caller's input rather than surfacing mid-render. The CV's are in
// `cv-checks.typ`.

#import "../design/icon-set.typ": _fa-glyphs, _icon-glyphs
#import "../design/theme.typ": _default-theme, _token-prefs, _tokens
#import "../design/theme-checks.typ": _check-tokens
#import "../util/checks.typ": (
  _bool-rule, _check, _check-keys, _check-rules, _check-type,
  _check-unknown-keys, _enum-rule, _list-rule, _positive-int-rule, _type-rule,
)
#import "../util/dates.typ": _check-date-template, _date-format-aliases
#import "../util/values.typ": _placeholder-re, _present-str

// `link-contact-info` channels: checked here, resolved per channel in
// `data/contacts.typ`.
#let _contact-channels = ("email", "phone", "location", "url", "profiles")

// Unknown keys panic rather than being silently absorbed. The keys
// named in `tables` (`labels.publication-types`) hold dictionaries that
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

// Every spacing token multiplies `body-size`, so it must be an absolute
// length: `1em` would resolve against itself, and a bare number reaches
// `set text(...)` as a stray positional.
#let _is-body-size(v) = type(v) == length and v.em == 0 and v.abs > 0pt

#let _is-margin-side(v) = type(v) in (length, ratio, relative) or v == auto
#let _is-margin(v) = if type(v) == dictionary {
  v.values().all(_is-margin-side)
} else { _is-margin-side(v) }

// A named formatter, a bracketed template (its tokens are left to
// `_apply-date-template`), or a closure.
#let _is-date-format(v) = (
  type(v) == function
    or (
      type(v) == str and ("[" in v or v == "iso" or v in _date-format-aliases)
    )
)

// The icon tables' value rules: icon-set keys, except `profile-icons`,
// which takes raw FontAwesome glyph names, as it draws networks the
// icon set doesn't ship. Too many to list, so its message points at
// the catalogue instead.
#let _icon-name-rule = _enum-rule(_icon-glyphs.keys())
#let _icon-table-rules = (
  profile-icons: (
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

// A column's section keys; a bare string (`"work"`) is the common
// slip for `("work",)`.
#let _column-sections-rule = _list-rule(
  (str,),
  "an array of section keys (e.g. (\"work\",))",
)

// The preferences' rules, in `_default-preferences`' order. The rest
// are checked in `_validate-preferences` (`font` and `colours` with
// the theme's tokens), or for the icon tables in `_merge-options`;
// `group-certificates` and `show-pronouns` are ignored, so they aren't
// checked.
#let _preference-rules = (
  body-size: (_is-body-size, "a positive absolute length (e.g. 10pt)"),
  uppercase-name: _bool-rule,
  header-text-align: _enum-rule((left, center, right)),
  photo-size: _type-rule((length, ratio, relative), "a length (e.g. 6em)"),
  photo-shape: _enum-rule(_default-theme.header.photo-radius.keys()),
  // The side of the header text the photo takes.
  photo-position: _enum-rule((left, right, top, bottom)),
  // Deprecated (#239): read into `photo-position` with `"center"`, but
  // checked even when unused, so a typo surfaces before it matters.
  image-stack-order: _enum-rule(("above", "below")),
  // A typo (`qr-code: true`) fails here, not inside `qrcode(...)`.
  qr-code: (
    v => v == none or v == auto or _present-str(v),
    "`none`, `auto`, or a non-empty URL string",
  ),
  paper: _type-rule((str,), "a paper name (e.g. \"a4\")"),
  margin: (
    _is-margin,
    "a length, `auto`, or a dict of them (e.g. (x: 1cm, y: 1.5cm))",
  ),
  column-ratio: (
    v => type(v) in (int, float) and v > 0 and v <= 1,
    "a number in (0, 1]",
  ),
  left-column-sections: _column-sections-rule,
  right-column-sections: _column-sections-rule,
  page-footer: (
    v => v == none or v == auto or type(v) == content,
    "`none`, `auto`, or a content value",
  ),
  last-modified-footer: _bool-rule,
  footer-version: _bool-rule,
  date-format: (
    _is-date-format,
    "\"long\", \"short\", \"iso\", a bracketed template "
      + "(e.g. \"[day]/[month]/[year]\"), or a closure",
  ),
  print-full-urls: _bool-rule,
  maps-provider: (
    v => v == none or (type(v) == str and "{q}" in v),
    "`none` or a URL template string containing `{q}`",
  ),
  max-rating: _positive-int-rule,
  skill-level-display: (
    v => v == auto or v in ("rating", "text"),
    "`auto`, \"rating\" or \"text\"",
  ),
  owner-names: _list-rule((str,), "an array of strings"),
  references-available-on-request: _bool-rule,
)

#let _validate-theme(prefs) = _check-tokens(_token-prefs(prefs), _tokens, "")

// `section-keys` is passed in, not imported: `data/sections.typ`
// imports this module, through `canonical.typ`.
#let _validate-preferences(prefs, section-keys) = {
  _check-rules(prefs, _preference-rules)
  _validate-theme(prefs)
  let link-contact-info = prefs.link-contact-info
  _check-type(
    "link-contact-info",
    link-contact-info,
    (bool, dictionary),
    "a bool or a dict",
  )
  if type(link-contact-info) == dictionary {
    _check-unknown-keys(
      link-contact-info.keys(),
      _contact-channels,
      "link-contact-info",
    )
    for (channel, v) in link-contact-info {
      _check("link-contact-info." + channel, v, _bool-rule)
    }
  }
  if type(prefs.date-format) == str {
    _check-date-template(prefs.date-format, "date-format")
  }
  for key in ("left-column-sections", "right-column-sections") {
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
  publication-icons: _type-rule((dictionary,), "a dictionary"),
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
  _validate-template-label(labels, "page-number", ("current",), ("total",))
  _validate-template-label(labels, "document-title", ("name",), ())
}
