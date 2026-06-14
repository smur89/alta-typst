// altacv — a two-column CV template for Typst. Visually descended from
// LianTze Lim's AltaCV LaTeX class (https://github.com/liantze/AltaCV,
// LPPL); forked from George Honeywood's alta-typst
// (https://github.com/GeorgeHoneywood/alta-typst, MIT, © 2023 George
// Honeywood) and rewritten around a JSON Resume-style data dict.
//
// Spacing tokens are em-multipliers of `body-size`, so changing one
// knob scales the document proportionally. The few absolute values
// (page margins, column gutter, rule thicknesses) are visual choices
// independent of text size.

// Curated accent presets. Each is dark enough to stay legible on
// white against the grey body text (`#666666`) and to survive a
// black-and-white photocopy as a distinguishable mid-tone. `teal`
// matches the historical default; the rest were eyeballed against
// the heading rule, tag fills (accent.lighten(85%)), and link colour.
// Callers reference them as `accent: palettes.navy` after importing.
// Defined up here (above the state and the default-preferences dict)
// so both can reference `palettes.teal` instead of duplicating the hex.
#let palettes = (
  teal:     rgb("#00796B"),
  navy:     rgb("#1A3A6C"),
  crimson:  rgb("#9E2A2B"),
  forest:   rgb("#2E5E3A"),
  plum:     rgb("#5F2A6E"),
  charcoal: rgb("#3B3B3B"),
)

// State set by alta() at render time and read by helpers below.
#let _body_size_state = state("alta-body-size", 10pt)
#let _accent_state = state("alta-accent", palettes.teal)
#let _max_rating_state = state("alta-max-rating", 5)

// Accent is configurable via alta(); the rest are opinionated.
#let _body_colour = rgb("#666666")
#let _emphasis_colour = rgb("#2E2E2E")
#let _empty_dot_colour = rgb("#c0c0c0")
#let _divider_colour = rgb("#D1D1D1")

// Label keys mirror JSON Resume's section keys (`work`, `certificates`,
// …) so callers think in a single vocabulary. The values are editorial:
// "Experience" reads better than "Work" as a CV heading,
// "Certifications" than "Certificates".
#let _default_labels = (
  work: "Experience",
  volunteer: "Volunteer",
  focusAreas: "Areas of Focus",
  skills: "Skills",
  languages: "Languages",
  education: "Education",
  certificates: "Certifications",
  publications: "Publications",
  awards: "Awards",
  projects: "Projects",
  interests: "Interests",
  articles: "Articles",
  present: "Present",
  lastModified: "Last updated",
  // Twelve abbreviated month names, January–December. Used by the
  // built-in `dateFormat: "long"` formatter to render ISO 8601 inputs
  // (e.g. "2024-06" → "Jun 2024"). Override to localise; the array
  // must keep length 12 (validated in alta()).
  months: ("Jan", "Feb", "Mar", "Apr", "May", "Jun",
           "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
  // Per-`publications[].type` icon overrides. Keys match the `type`
  // string (case-insensitive); values are utility-icon names. The
  // module ships sensible defaults for `Articles`, `Books`, `Talks`,
  // `Conference Papers`, etc. — see `_default_publication_icons` —
  // and falls back to `file` for unknown types. Override here to add
  // custom types or remap built-ins.
  publicationIcons: (:),
)

// Exported so callers can write `mapsProvider: maps-providers.google`
// rather than the literal URL. `{q}` is substituted with the URL-
// encoded location at render time.
#let maps-providers = (
  google: "https://www.google.com/maps?q={q}",
  apple: "https://maps.apple.com/?q={q}",
  bing: "https://www.bing.com/maps?q={q}",
  duckduckgo: "https://duckduckgo.com/?q={q}&iaxm=maps",
  osm: "https://www.openstreetmap.org/search?query={q}",
)

// Panics on unknown keys so typos surface as errors instead of being
// silently absorbed.
#let _strict_merge(defaults, overrides, name) = {
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

// JSON Resume defines `basics.location` as a structured dict —
// `{address, postalCode, city, countryCode, region}`. The CV header
// wants a single line, not five fields, so the dict form is collapsed
// into a string by joining the CV-relevant subset (`city`, `region`,
// `countryCode`) with ", ", skipping any field that's missing or
// empty. `address` and `postalCode` are accepted (so a verbatim
// `resume.json` dict round-trips without panicking) but not rendered
// — a CV header isn't a mailing label.
//
// The resulting string drives both the displayed text and the maps
// deep link, so the link target stays consistent with what the reader
// sees. Unknown keys panic to surface typos.
#let _location_fields = ("address", "postalCode", "city", "countryCode", "region")
#let _location_display_order = ("city", "region", "countryCode")
#let _format_location(value) = {
  if value == none { return none }
  if type(value) == str { return value }
  if type(value) != dictionary {
    panic(
      "basics.location must be a string or a dict matching JSON Resume's"
        + " {address, postalCode, city, countryCode, region}, got: " + repr(value),
    )
  }
  let unknown = value.keys().filter(k => k not in _location_fields)
  if unknown.len() > 0 {
    let quote(k) = "\"" + k + "\""
    panic(
      "Unknown basics.location key(s): " + unknown.map(quote).join(", ")
        + ". Supported: " + _location_fields.map(quote).join(", "),
    )
  }
  let parts = _location_display_order
    .map(k => value.at(k, default: none))
    .filter(v => v != none and v != "")
  if parts.len() == 0 { return none }
  parts.join(", ")
}

// Per RFC 3986. Iterates UTF-8 bytes (not codepoints), so non-Latin
// locations like "Zürich" or "京都" round-trip through the maps URL.
#let _url_encode(s) = {
  let unreserved = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
  let hex = "0123456789ABCDEF"
  let out = ""
  for b in array(bytes(s)) {
    if b < 128 and str.from-unicode(b) in unreserved {
      out += str.from-unicode(b)
    } else {
      out += "%" + hex.at(int(b / 16)) + hex.at(int(calc.rem(b, 16)))
    }
  }
  out
}

// Every SVG ships with fill="#666666" baked in so icon() can colour-
// swap by string replace at call time. Any new icon vendored into
// `icons/` must follow that convention.
#let _utility_icon_sources = (
  book: read("icons/book.svg"),
  calendar: read("icons/calendar.svg"),
  email: read("icons/email.svg"),
  file: read("icons/file.svg"),
  location: read("icons/location.svg"),
  microphone: read("icons/microphone.svg"),
  newspaper: read("icons/newspaper.svg"),
  phone: read("icons/phone.svg"),
)
#let _network_icon_sources = (
  bluesky: read("icons/bluesky.svg"),
  github: read("icons/github.svg"),
  gitlab: read("icons/gitlab.svg"),
  link: read("icons/link.svg"),
  linkedin: read("icons/linkedin.svg"),
  mastodon: read("icons/mastodon.svg"),
  medium: read("icons/medium.svg"),
  stackoverflow: read("icons/stackoverflow.svg"),
  twitter: read("icons/twitter.svg"),
  website: read("icons/website.svg"),
)
#let _icon_sources = _utility_icon_sources + _network_icon_sources
#let _profile_networks = _network_icon_sources.keys()

// Maps renamed networks onto the icon we still ship under the old
// name. The lookup happens after `lower(profile.network)`.
#let _network_aliases = (
  x: "twitter",
)

// ─── Public helpers ──────────────────────────────────────────────────

// Renders a vendored SVG sized to the surrounding text. Emits a small
// trailing `h(...)` so callers don't need to add inter-icon spacing
// themselves; suppress it by wrapping in `box(...)` if undesired.
#let icon(name, size: auto, shift: auto, fill: auto) = context {
  let body-size = _body_size_state.get()
  let resolved-size = if size == auto { body-size } else { size }
  let resolved-shift = if shift == auto { 0.15 * body-size } else { shift }
  let resolved-fill = if fill == auto { _body_colour } else { fill }

  let coloured = _icon_sources.at(name).replace(
    _body_colour.to-hex(),
    resolved-fill.to-hex(),
  )
  box(
    baseline: resolved-shift,
    width: resolved-size,
    height: resolved-size,
    align(
      center + horizon,
      image(bytes(coloured), format: "svg", height: 0.9 * resolved-size),
    ),
  )
  h(0.3 * body-size)
}

// Bold accent-coloured line — designed for the company / institution
// row beneath a role or education entry.
#let name(body) = context {
  let body-size = _body_size_state.get()
  let accent = _accent_state.get()
  block(
    above: 0pt,
    below: 0.6 * body-size,
    text(weight: "bold", fill: accent, body),
  )
}

// Either side may be `none` — the box is skipped, so undated /
// unlocated entries don't emit a stray icon.
#let term(period, location: none) = context {
  if period == none and location == none { return }
  let body-size = _body_size_state.get()
  block(
    above: 0pt,
    below: 0.8 * body-size,
    inset: (left: 0.3 * body-size),
    text(0.9 * body-size, {
      if period != none {
        box(width: 50%, {
          icon("calendar")
          period
        })
      }
      if location != none {
        box(width: 50%, {
          icon("location")
          location
        })
      }
    }),
  )
}

// Half-fill (1.5 → 1 full + 1 half + 3 empty) uses a 50%/50% linear
// gradient — Typst has no native half-circle fill, and a gradient
// produces a sharp boundary where a transparent overlay wouldn't.
//
// LinkedIn-style fluency strings. Numeric `rating` wins over `fluency`
// when an entry supplies both, so callers can opt into fractional
// precision without rewriting their data. The fluency map is fixed at
// a 0–5 scale (LinkedIn's); callers using `preferences.maxRating` for a
// non-5 scale (e.g. CEFR's 6) must pass numeric `rating` values.
#let _fluency_rating = (
  "Native":               5,
  "Bilingual":            5,
  "Full Professional":    4,
  "Professional Working": 3,
  "Limited Working":      2,
  "Elementary":           1,
)
// Resolves an entry to a rating. Type and bounds validation are
// deferred to `rating()` (which runs inside a `context` block and can
// read the configured `_max_rating_state`); this function only handles
// the numeric-vs-fluency dispatch.
#let _resolve_rating(entry) = {
  // Bound to `value` rather than `rating` so the module-scope public
  // `rating()` helper isn't shadowed inside this function.
  let value = entry.at("rating", default: none)
  if value != none { return value }
  let fluency = entry.at("fluency", default: none)
  if fluency != none {
    if type(fluency) == str and fluency in _fluency_rating { return _fluency_rating.at(fluency) }
    panic("Unknown fluency level: " + repr(fluency) + ". Provide a numeric `rating` instead, or use one of: " + _fluency_rating.keys().join(", "))
  }
  panic("Language entry needs either a numeric `rating` or a `fluency` string.")
}
#let _half_fill(accent) = gradient.linear(
  (accent, 0%),
  (accent, 50%),
  (_empty_dot_colour, 50%),
  (_empty_dot_colour, 100%),
)
#let rating(label, value) = context {
  let body-size = _body_size_state.get()
  let accent = _accent_state.get()
  let max-rating = _max_rating_state.get()
  if type(value) not in (int, float) {
    panic("Rating must be numeric, got: " + repr(value))
  }
  if value < 0 or value > max-rating {
    panic("Rating out of range: " + repr(value) + ". Expected 0–" + str(max-rating) + ".")
  }
  let dot-radius = 0.45 * body-size
  let dot-baseline = -0.25 * body-size
  let dot-spacing = 0.4 * body-size

  text(label)
  h(1fr)
  for i in range(1, max-rating + 1) {
    let fill = if value >= i {
      accent
    } else if value > i - 1 {
      _half_fill(accent)
    } else {
      _empty_dot_colour
    }
    box(baseline: dot-baseline, circle(radius: dot-radius, fill: fill))
    if i != max-rating { h(dot-spacing) }
  }
  [\ ]
}

// `label: true` is the category-heading variant (darker fill, bold
// text) — used to distinguish a group's leading pill from the item
// pills that follow it on the same row. `trailing: false` suppresses
// the inter-tag gap that would otherwise sit after the pill; callers
// composing a row of tags pass `false` on the final one so the row
// doesn't end on dead horizontal space.
#let tag(body, label: false, trailing: true) = context {
  let body-size = _body_size_state.get()
  let accent = _accent_state.get()
  let fill-colour = if label { accent.lighten(70%) } else { accent.lighten(85%) }
  let text-weight = if label { "bold" } else { "regular" }
  box(
    fill: fill-colour,
    stroke: 0.5pt + accent,
    radius: 2.5pt,
    inset: (x: 0.4 * body-size, y: 0.15 * body-size),
    outset: (y: 0.15 * body-size),
    text(0.85 * body-size, fill: accent.darken(15%), weight: text-weight, body),
  )
  if trailing { h(0.25 * body-size) }
}

#let divider() = context {
  let body-size = _body_size_state.get()
  v(0.3 * body-size)
  line(
    length: 100%,
    stroke: (paint: _divider_colour, thickness: 0.6pt, dash: "dashed"),
  )
  v(0.3 * body-size)
}

// Like `divider()` but with a leading label that sits slightly indented
// from the left edge, followed by the dashed segment running to the
// right margin. Used to announce a sub-grouping (e.g. the certificates'
// issuer above its row of cert pills). The label borrows the section-
// heading register (uppercase, tracked) at a smaller scale and in body
// colour so it reads as a quiet sub-heading rather than competing with
// the parent section title.
#let _labelled_divider(label) = context {
  let body-size = _body_size_state.get()
  let stroke = (paint: _divider_colour, thickness: 0.6pt, dash: "dashed")
  v(0.3 * body-size)
  pad(left: 0.6 * body-size, grid(
    columns: (1.3em, auto, 1fr),
    column-gutter: 0.5 * body-size,
    align: horizon,
    line(length: 100%, stroke: stroke),
    text(
      0.7 * body-size,
      fill: _body_colour.lighten(15%),
      label,
    ),
    line(length: 100%, stroke: stroke),
  ))
  v(0.3 * body-size)
}

// Interleaves `divider()` between items; the trailing one is suppressed
// so sections don't end on a stray rule.
#let _join_with_dividers(items, render) = {
  for (i, item) in items.enumerate() {
    render(item)
    if i < items.len() - 1 { divider() }
  }
}

// Suppresses the inter-tag gap on the final pill so rows don't end
// in dead horizontal space.
#let _tag_row(items) = {
  for (i, item) in items.enumerate() {
    tag(item, trailing: i < items.len() - 1)
  }
}

// Accent-coloured italic link — used for publication and project titles.
#let styled-link(dest, content) = context {
  let accent = _accent_state.get()
  emph(text(fill: accent, link(dest, content)))
}

// Wraps `title` in `styled-link` when a URL is supplied. Used by every
// section renderer that wants the same "linked when possible, plain
// when not" behaviour; the `fallback` opt-out lets callers tweak the
// unlinked variant (e.g. `_publications` italicises the bare title).
#let _titled_link(title, url, fallback: auto) = {
  let plain = if fallback == auto { title } else { fallback }
  if url != none { styled-link(url, title) } else { plain }
}

// ─── Meta helpers ────────────────────────────────────────────────────

// JSON Resume's `meta.lastModified` is ISO 8601 — either a bare date
// ("2026-06-12") or a full timestamp ("2026-06-12T14:00:00Z"). We only
// need the calendar part for `set document(date: ...)` (PDF readers
// surface day-level precision in their metadata panel). Returns `none`
// for malformed input so callers can fall back to omitting the field;
// the visible footer renders the original string verbatim, so a
// non-parseable timestamp still surfaces to the reader.
#let _parse_iso_datetime(s) = {
  if type(s) != str { return none }
  let m = s.match(regex("^(\d{4})-(\d{2})-(\d{2})"))
  if m == none { return none }
  let (y, mo, d) = m.captures.map(int)
  if mo < 1 or mo > 12 or d < 1 { return none }
  // Reject calendar-invalid days *before* calling datetime(), which
  // panics (unrecoverably) on e.g. Feb 31 or Feb 29 in a non-leap
  // year. Falling back to `none` here lets the caller drop the field
  // and use compile time, matching the documented behaviour.
  let is-leap = calc.rem(y, 4) == 0 and (calc.rem(y, 100) != 0 or calc.rem(y, 400) == 0)
  let days-in-month = (31, if is-leap { 29 } else { 28 }, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
  if d > days-in-month.at(mo - 1) { return none }
  datetime(year: y, month: mo, day: d)
}

// Flatten every skill group's `keywords` into a de-duplicated array
// for the PDF `Keywords` field. Insertion order is preserved so the
// metadata reflects the author's curated ordering.
#let _collect_keywords(skills) = {
  let seen = ()
  for group in skills {
    for kw in group.at("keywords", default: ()) {
      if type(kw) == str and kw != "" and kw not in seen { seen.push(kw) }
    }
  }
  seen
}

// ─── Section renderers (internal) ────────────────────────────────────

// Rejects `none`, the empty string, and the empty content block —
// the three ways a section field can be effectively absent.
#let _present(v) = v != none and v != "" and v != []

// ── Date formatting ─────────────────────────────────────────────────
//
// JSON Resume's iso8601 pattern accepts three partial shapes:
// `YYYY-MM-DD`, `YYYY-MM`, and `YYYY` (verified against the schema's
// `iso8601` regex). Typst's built-in `datetime` type cannot represent
// the latter two — it stores either a full date, a time, or a full
// datetime, with no year-only or year-month variant — so we keep a
// custom `(year, month: opt int, day: opt int)` dict for partials.
// `datetime.display()` is also locked to English month/weekday names
// today (Typst plans localisation in the future), which would defeat
// `labels.months`, so we render names from the labels dict instead of
// delegating. We still mirror Typst's bracketed format-string syntax
// (`[year]`, `[month repr:long]`, …) so call sites can carry the same
// template into other Typst code if they need to.

// Tries to parse `s` as an ISO 8601 calendar date prefix — `yyyy`,
// `yyyy-mm`, or `yyyy-mm-dd`. Returns a `(year, month, day)` dict
// (month/day may be `none`) on success, or `none` if the input doesn't
// match. Matching is strict on shape (zero-padded, hyphen-separated)
// and on calendar validity (months 1–12, days 1–31). Anything else —
// "Jan 2022", "2024/06", "May 2016 – Jul 2017" — falls through to
// verbatim rendering by callers.
#let _parse_iso_date(s) = {
  if type(s) != str { return none }
  let m = s.match(regex("^(\d{4})(?:-(\d{2})(?:-(\d{2}))?)?$"))
  if m == none { return none }
  let (year, month, day) = m.captures
  let year-num = int(year)
  let month-num = if month == none { none } else { int(month) }
  let day-num = if day == none { none } else { int(day) }
  if month-num != none and (month-num < 1 or month-num > 12) { return none }
  if day-num != none and (day-num < 1 or day-num > 31) { return none }
  (year: year-num, month: month-num, day: day-num)
}

// Built-in named formatters. Each takes a parsed ISO date dict and
// the labels dict (for `months` localisation) and returns a string.
// `"iso"` is a passthrough — the caller renders the original string,
// so we never reach these for that case.
#let _format_iso_long(parts, labels) = {
  if parts.month == none { return str(parts.year) }
  let month-name = labels.months.at(parts.month - 1)
  if parts.day == none {
    month-name + " " + str(parts.year)
  } else {
    str(parts.day) + " " + month-name + " " + str(parts.year)
  }
}
#let _pad2(n) = if n < 10 { "0" + str(n) } else { str(n) }
#let _format_iso_short(parts, labels) = {
  if parts.month == none { return str(parts.year) }
  if parts.day == none {
    _pad2(parts.month) + "/" + str(parts.year)
  } else {
    _pad2(parts.day) + "/" + _pad2(parts.month) + "/" + str(parts.year)
  }
}
#let _named_date_formatters = (
  long: _format_iso_long,
  short: _format_iso_short,
)

// Resolves a single bracketed token from a Typst-style format template
// (e.g. "year", "month repr:long", "day padding:none") against the
// parsed parts. Missing components (month/day on a year-only or
// year-month input) substitute a sentinel marker (see SEP_DROP below)
// so adjacent separators can be collapsed by the caller. Mirrors a
// subset of Typst's own `datetime.display()` token syntax — the
// supported tokens are `year`, `month`, and `day`, with
// `repr:long`/`repr:short`/`repr:numerical` for `month` (the long/short
// forms read from `labels.months` so they localise) and
// `padding:none`/`padding:zero` for the numeric forms.
#let _DATE_TOKEN_DROP = "\u{FFFD}"  // Private placeholder for missing parts.
#let _resolve_date_token(token, parts, labels) = {
  let parts-list = token.split(" ")
  let head = parts-list.first()
  let modifiers = parts-list.slice(1)
  let has(m) = modifiers.contains(m)
  if head == "year" {
    // Year is always 4 digits from the regex, so `padding:` is a no-op.
    str(parts.year)
  } else if head == "month" {
    if parts.month == none { return _DATE_TOKEN_DROP }
    if has("repr:long") {
      labels.months.at(parts.month - 1)
    } else if has("repr:short") {
      let full = labels.months.at(parts.month - 1)
      full.slice(0, calc.min(3, full.len()))
    } else if has("padding:none") {
      str(parts.month)
    } else {
      _pad2(parts.month)
    }
  } else if head == "day" {
    if parts.day == none { return _DATE_TOKEN_DROP }
    if has("padding:none") {
      str(parts.day)
    } else {
      _pad2(parts.day)
    }
  } else {
    panic("Unknown dateFormat token: [" + token + "]. Supported: year, month, day (each with optional `padding:` / `repr:` modifiers).")
  }
}

// Applies a Typst-style bracketed template like "[day]/[month]/[year]"
// to the parsed parts. Missing components emit a private sentinel
// marker; a final pass strips each sentinel together with the
// whitespace and surrounding non-alphanumeric separator characters
// that bordered it, so a year-only input under template
// `[day] · [month repr:short] [year]` renders as just `2024` rather
// than `· · 2024`.
#let _apply_date_template(template, parts, labels) = {
  let body = template.replace(
    regex("\[([^\]]+)\]"),
    m => _resolve_date_token(m.captures.at(0), parts, labels),
  )
  // Strip the sentinel together with any run of separator-class chars
  // on either side. "Separator" here is anything that isn't a letter
  // or digit — covers ASCII (`/`, `-`, `,`, `.`, space) and Unicode
  // (`·`, `—`, `–`, etc.) so callers can use exotic glyphs without
  // worrying about whether we know about them.
  body
    .replace(regex("[^\p{L}\p{N}]*" + _DATE_TOKEN_DROP + "[^\p{L}\p{N}]*"), " ")
    .replace(regex("\s+"), " ")
    .trim()
}

// Single entry point used by every renderer that surfaces a date.
// Non-string and non-ISO inputs pass through verbatim (back-compat with
// pre-formatted strings like "Jan 2022"). A closure formatter receives
// the parsed `(year, month, day)` dict and must return a string. The
// `"iso"` named formatter is just passthrough of the original input.
// String values containing `[` are treated as bracketed format
// templates (see `_apply_date_template`); other strings are looked up
// in `_named_date_formatters`.
#let _format_date(value, prefs, labels) = {
  if value == none or value == "" { return value }
  let format = prefs.dateFormat
  if format == "iso" { return value }
  let parts = _parse_iso_date(value)
  if parts == none { return value }
  if type(format) == str {
    if "[" in format {
      _apply_date_template(format, parts, labels)
    } else {
      (_named_date_formatters.at(format))(parts, labels)
    }
  } else {
    // Closure contract: `(parts) -> str`. Validated up front in
    // alta(); we just call it here.
    format(parts)
  }
}

// Returns `none` when neither date is supplied so callers can skip
// emitting the term row, rather than falsely rendering "Present" for
// a fully undated entry.
#let _format_date_range(entry, labels, prefs) = {
  let is-empty(v) = v == none or v == ""
  let start = entry.at("startDate", default: none)
  let end = entry.at("endDate", default: none)
  if is-empty(start) and is-empty(end) { return none }
  let start-text = if is-empty(start) { none } else { _format_date(start, prefs, labels) }
  let end-text = if is-empty(end) { labels.present } else { _format_date(end, prefs, labels) }
  if start-text == none { [#end-text] } else { [#start-text – #end-text] }
}

// String-path sources resolve relative to lib.typ (not the user's
// document), so callers should prefer a leading "/" for a root-
// relative path or pass bytes via `read("path", encoding: none)`.
// `fit: "cover"` is what keeps non-square sources from distorting.
#let _portrait(source, size) = box(
  width: size,
  height: size,
  clip: true,
  radius: 50%,
  image(source, fit: "cover", width: 100%, height: 100%),
)

#let _contact_channels = ("email", "phone", "location", "url", "profiles")

// Returns a fully-populated per-channel dict so downstream code can
// always `link-config.at(channel)` without missing-key guards.
#let _resolve_link_config(value) = {
  // Sourcing the channel set from `_contact_channels` keeps adding a
  // fifth channel a one-line change there, not here.
  let all-channels(v) = _contact_channels.fold((:), (acc, c) => acc + ((c): v))
  if type(value) == bool {
    all-channels(value)
  } else if type(value) == dictionary {
    let unknown = value.keys().filter(k => k not in _contact_channels)
    if unknown.len() > 0 {
      let quote(k) = "\"" + k + "\""
      panic(
        "Unknown linkContactInfo channel(s): " + unknown.map(quote).join(", ")
          + ". Supported: " + _contact_channels.map(quote).join(", "),
      )
    }
    // Per-channel values must be bools. Validating up front gives a
    // precise error message anchored to the user's input rather than
    // letting non-bools propagate to the render-time `if` check
    // (which would panic with a generic "expected boolean" message).
    for (k, v) in value.pairs() {
      if type(v) != bool {
        panic(
          "linkContactInfo." + k + " must be a bool, got: " + repr(v),
        )
      }
    }
    all-channels(true) + value
  } else {
    panic(
      "linkContactInfo must be a bool or a dict, got: " + repr(value),
    )
  }
}

#let _header(
  basics,
  image-size: 6em,
  image-position: "right",
  image-stack-order: "above",
  header-text-align: "left",
  link-contact-info: true,
  maps-provider: maps-providers.google,
  uppercase-name: true,
) = {
  if image-position not in ("left", "right", "center") {
    panic("imagePosition must be \"left\", \"right\", or \"center\", got: " + repr(image-position))
  }
  // Only meaningful when image-position == "center"; validated unconditionally
  // so a typo surfaces even if the caller later flips the position.
  if image-stack-order not in ("above", "below") {
    panic("imageStackOrder must be \"above\" or \"below\", got: " + repr(image-stack-order))
  }
  let text-align = (
    if header-text-align == "left" { left }
    else if header-text-align == "right" { right }
    else if header-text-align == "center" { center }
    else {
      panic(
        "headerTextAlign must be \"left\", \"right\", or \"center\", got: "
          + repr(header-text-align),
      )
    }
  )
  let link-config = _resolve_link_config(link-contact-info)
  context {
    let body-size = _body_size_state.get()
    let accent = _accent_state.get()

    let header-text = align(text-align, {
      block(
        spacing: 0pt,
        below: 1.2 * body-size,
        text(
          2.5 * body-size,
          fill: accent,
          weight: "bold",
          if uppercase-name { upper(basics.name) } else { basics.name },
        ),
      )

      if "label" in basics and basics.label != none {
        block(
          spacing: 0pt,
          below: 0.8 * body-size,
          text(1.2 * body-size, fill: _emphasis_colour, weight: "bold", basics.label),
        )
      }

      set text(0.8 * body-size, weight: "bold")
      let bar-icon = icon.with(size: 0.9 * body-size, shift: 0.2 * body-size, fill: accent)

      let entries = ()
      let email = basics.at("email", default: none)
      if email != none {
        entries.push((
          channel: "email",
          icon: "email",
          value: email,
          url: "mailto:" + email,
        ))
      }
      let phone = basics.at("phone", default: none)
      if phone != none {
        // Strip RFC 3966 visual separators (spaces, parens, hyphens, dots)
        // from the dialable URI; the displayed value keeps them intact.
        let dialable = phone.replace(regex("[\s()\-.]"), "")
        entries.push((
          channel: "phone",
          icon: "phone",
          value: phone,
          url: "tel:" + dialable,
        ))
      }
      // `_format_location` collapses the JSON Resume dict form
      // `{address, postalCode, city, countryCode, region}` to a
      // single line, leaves an already-flat string untouched, and
      // returns `none` when every relevant field is empty. Both the
      // display value and the maps deep link are fed from the same
      // result so they cannot drift.
      let location = _format_location(basics.at("location", default: none))
      if location != none {
        let url = if maps-provider == none { none } else {
          maps-provider.replace("{q}", _url_encode(location))
        }
        entries.push((
          channel: "location",
          icon: "location",
          value: location,
          url: url,
        ))
      }
      let url = basics.at("url", default: none)
      if url != none {
        entries.push((
          channel: "url",
          icon: "link",
          value: url,
          url: url,
        ))
      }
      for profile in basics.at("profiles", default: ()) {
        let raw = lower(profile.network)
        let network = _network_aliases.at(raw, default: raw)
        if network not in _profile_networks {
          panic(
            "Unknown profile network: " + repr(profile.network)
              + ". Supported: " + _profile_networks.join(", ")
              + ". To add another, vendor its SVG into icons/ and register it in _network_icon_sources.",
          )
        }
        entries.push((
          channel: "profiles",
          icon: network,
          value: profile.at("username", default: profile.at("url", default: "")),
          url: profile.url,
        ))
      }

      // Each entry is wrapped in `box(...)` so the icon and its
      // display text stay together when the contact bar wraps —
      // line breaks fall on the inter-entry `h(...)` joins, never
      // between an icon and the text it labels.
      entries
        .map(entry => box({
          bar-icon(entry.icon)
          let value = [#entry.value]
          if link-config.at(entry.channel) and entry.url != none {
            link(entry.url, value)
          } else { value }
        }))
        .join(h(1.2 * body-size))
      // Inherits par.spacing, so the gap stays in sync with the rest
      // of the document even when bodySize is tweaked.
      parbreak()
    })

    let image-src = basics.at("image", default: none)
    // Contract is `str` (path) or `bytes`. Both carry `len()`, so an
    // empty path ("") or empty bytes report 0 and skip the frame.
    // Anything else panics with a clear message instead of falling
    // through to a cryptic `image()` failure or — worse — silently
    // dropping the photo (which is what an empty array would do under
    // a bare `.len()` check).
    let has-image = if image-src == none {
      false
    } else if type(image-src) in (str, bytes) {
      image-src.len() > 0
    } else {
      panic(
        "basics.image must be a string path or bytes, got: " + repr(image-src),
      )
    }
    if has-image {
      // Swapping the column order moves the photo to the opposite
      // side without changing the alignment of the text within its
      // column — both branches keep `1fr` on the text side.
      let photo = _portrait(image-src, image-size)
      if image-position == "left" {
        grid(
          columns: (auto, 1fr),
          align: top,
          column-gutter: 1em,
          photo,
          header-text,
        )
      } else if image-position == "right" {
        grid(
          columns: (1fr, auto),
          align: top,
          column-gutter: 1em,
          header-text,
          photo,
        )
      } else {
        // Centred: stack the photo on its own row above or below the
        // text block. `header-text` already honours `headerTextAlign`,
        // so wrapping the photo in `align(center, ...)` is enough to
        // place it on the page's centre axis regardless of how the
        // text below/above it is aligned.
        let centred-photo = block(
          spacing: 0.8 * body-size,
          align(center, photo),
        )
        if image-stack-order == "above" {
          centred-photo
          header-text
        } else {
          header-text
          centred-photo
        }
      }
    } else {
      header-text
    }
  }
}

#let _summary(basics) = context {
  let summary = basics.at("summary", default: none)
  if summary == none or summary == [] { return }
  let body-size = _body_size_state.get()
  v(0.8 * body-size)
  par(summary)
  v(0.4 * body-size)
}

// JSON Resume's `work[]` carries a `summary` (a short paragraph
// describing the role) and some exporters also populate `description`.
// We treat them as alternatives that fill the same slot between the
// term row and the highlights list — `summary` wins when both are
// present so callers can opt into either field name without surprises.
#let _experience(work, labels, prefs) = if work.len() > 0 [
  == #labels.work

  #_join_with_dividers(work, job => [
    #block(breakable: false)[
      === #job.position
      // `link()` inherits the surrounding bold + accent from `name()`,
      // so the company stays visually identical to the unlinked case
      // and just gains click behaviour. `styled-link` would impose the
      // italic / underline treatment used for publication titles.
      #let url = job.at("url", default: none)
      #name[#if url != none { link(url, job.name) } else { job.name }]
      #term(_format_date_range(job, labels, prefs), location: job.at("location", default: none))

      #let preamble = job.at("summary", default: job.at("description", default: none))
      #if _present(preamble) [
        // Softer than `name()` (the bold accent line above) — same
        // treatment as `projects[].description` — so the prose
        // preamble doesn't compete with the role headings or the
        // highlight bullets that follow.
        #emph(preamble)
      ]
      #for bullet in job.at("highlights", default: ()) [- #bullet]
    ]
  ])
]

// JSON Resume `volunteer[]` mirrors `work[]` shape, but uses
// `organization` where work uses `name`. Renderer is otherwise
// identical to `_experience`: position heading, accent-coloured
// organisation line, optional date range + location, bulleted
// highlights.
#let _volunteer(entries, labels, prefs) = if entries.len() > 0 [
  == #labels.volunteer

  #_join_with_dividers(entries, entry => [
    #block(breakable: false)[
      === #entry.position
      #name[#entry.at("organization", default: "")]
      #term(_format_date_range(entry, labels, prefs), location: entry.at("location", default: none))

      #for bullet in entry.at("highlights", default: ()) [- #bullet]
    ]
  ])
]

#let _focus_areas(items, labels) = if items.len() > 0 [
  == #labels.focusAreas

  #for item in items [- #item]
]

// `text("-")` (not `[-]`) — markup-bracketed `-` parses as a list-item
// bullet. The trailing `h(...)` after the dash mirrors the gap that
// `tag()` already emits to its left, keeping the label pill visually
// centred between its two whitespace gutters.
//
// Shared by `_skills` and `_interests` — both consume the same JSON
// Resume `{name, keywords}` shape, so the layout is identical; only
// the heading differs.
#let _name_keywords_section(groups, heading) = if groups.len() > 0 {
  context {
    let body-size = _body_size_state.get()
    let row-gap = 0.7 * body-size
    [== #heading]
    for group in groups {
      let keywords = group.at("keywords", default: ())
      if keywords.len() == 0 { continue }
      block(above: 0pt, below: row-gap, par(hanging-indent: 1em, leading: row-gap, {
        tag(group.name, label: true)
        text("-")
        h(0.25 * body-size)
        _tag_row(keywords)
      }))
    }
  }
}

#let _skills(groups, labels) = _name_keywords_section(groups, labels.skills)

#let _interests(groups, labels) = _name_keywords_section(groups, labels.interests)

#let _languages(items, labels) = if items.len() > 0 [
  == #labels.languages

  #_join_with_dividers(items, lang => block(
    breakable: false,
    rating(lang.language, _resolve_rating(lang)),
  ))
]

#let _education(entries, labels, prefs) = if entries.len() > 0 [
  == #labels.education

  #_join_with_dividers(entries, edu => [
    #block(breakable: false)[
      #let title = edu.at("studyType", default: edu.at("area", default: ""))
      #if title != "" [=== #title]
      #let institution = edu.at("institution", default: "")
      #let url = edu.at("url", default: none)
      #let body = name[#institution]
      // `link()` wraps the `name()` block as-is, so the accent-bold
      // treatment is preserved — the only visible change is that the
      // institution becomes clickable. An empty-string url is treated
      // as absent so a missing JSON field doesn't render a dead link.
      #if _present(url) and institution != "" { link(url, body) } else { body }
      #term(_format_date_range(edu, labels, prefs))

      #if "score" in edu and edu.score != none [#edu.score]
      // Courses render as pill tags — same treatment as `skills[].keywords`
      // and `projects[].keywords`, which are the other array-of-strings
      // surfaces in the template. Empty arrays skip silently.
      #let courses = edu.at("courses", default: ())
      #if courses.len() > 0 [
        #for course in courses [#tag(course)]
      ]
    ]
  ])
]

// Normalises a cert into the (name, date, url) triple the renderer
// consumes. Returns `none` for entries with no usable name so callers
// can filter them in one pass. `date` / `url` are normalised to `none`
// when absent or empty so downstream `!= none` checks don't render an
// orphan date snippet or a link with an empty target.
#let _normalise_cert(cert) = {
  let name = cert.at("name", default: "")
  if not _present(name) { return none }
  let date = cert.at("date", default: none)
  let url = cert.at("url", default: none)
  (
    name: name,
    date: if _present(date) { date } else { none },
    url: if _present(url) { url } else { none },
  )
}

// Buckets by issuer in insertion order; multi-issuer clusters survive
// as their own group keyed by the shared issuer, singletons pool into
// a trailing heterogeneous group with no issuer label.
//
// Returns an array of `(issuer, items)` records. `items` carries full
// `_normalise_cert` triples (name + date + url) so the renderer can
// emit inline dates and link wrapping without re-reading the source.
// `issuer` is `none` for the trailing singleton group (its certs come
// from different issuers, so no single label fits) or for clusters
// whose `issuer` field is missing / empty.
#let _build_cert_groups(certs) = {
  // Normalise "no issuer" (key missing, explicit `none`, or empty
  // string) to the literal "" key so they all bucket together; we
  // can't key the dict on `none` (Typst dicts require string keys).
  let by-issuer = (:)
  for cert in certs {
    let item = _normalise_cert(cert)
    if item == none { continue }
    let raw = cert.at("issuer", default: "")
    let issuer = if raw == none { "" } else { raw }
    by-issuer.insert(issuer, by-issuer.at(issuer, default: ()) + (item,))
  }
  let groups = ()
  let singletons = ()
  for (issuer, items) in by-issuer.pairs() {
    if items.len() > 1 {
      groups.push((issuer: if issuer == "" { none } else { issuer }, items: items))
    } else {
      singletons.push(items.first())
    }
  }
  if singletons.len() > 0 { groups.push((issuer: none, items: singletons)) }
  groups
}

// Builds a pill body containing the cert name and, when a date is
// supplied, a middot separator + small calendar icon + date — all in
// the pill's own text rendering. The icon and date are wrapped in a
// box so they never break across lines; only the middot's surrounding
// space is a valid break point if the pill has to wrap.
#let _cert_tag(item) = context {
  let body-size = _body_size_state.get()
  let body = if item.date != none {
    [#item.name#h(0.35 * body-size)·#h(0.35 * body-size)#box[#icon("calendar", size: 0.75 * body-size, shift: 0.1 * body-size)#item.date]]
  } else {
    [#item.name]
  }
  let pill = tag(body)
  if item.url != none { link(item.url, pill) } else { pill }
}

#let _certificates(certs, labels, group: true) = {
  if certs.len() == 0 { return }
  // Decide whether to emit the heading *after* filtering — otherwise
  // a list of certs whose `name` is empty would still render a bare
  // "Certifications" heading with nothing under it.
  //
  // Each group is `(issuer, items)` where `items` carries full
  // `_normalise_cert` triples. In flat (non-grouped) mode each cert
  // becomes its own one-element "group" with no issuer label so the
  // row flows as a single uniformly-pilled strip.
  let groups = if group {
    _build_cert_groups(certs)
  } else {
    let items = certs.map(_normalise_cert).filter(c => c != none)
    if items.len() > 0 { ((issuer: none, items: items),) } else { () }
  }
  if groups.len() == 0 { return }
  [== #labels.certificates]
  // Each group's issuer (when present) leads its row as a labelled
  // dashed divider — replacing the plain inter-group divider with one
  // that names the issuer. Groups without an issuer (the pooled
  // singletons cluster, or every group in flat mode) get the plain
  // divider; the first group is preceded by no divider regardless so
  // the section starts flush against the heading.
  for (i, g) in groups.enumerate() {
    if g.issuer != none { _labelled_divider(g.issuer) }
    else if i > 0 { divider() }
    block(breakable: false, { for item in g.items { _cert_tag(item) } })
  }
}

// Follows JSON Resume's `awards[]` shape, plus an `url` extension that
// wraps the title in an accent-coloured link (same treatment as
// `projects[].url`). Entries without a `title` are skipped so a stray
// entry can't emit an orphan heading.
#let _awards(entries, labels, prefs) = {
  let valid = entries.filter(a => _present(a.at("title", default: none)))
  if valid.len() == 0 { return }
  [== #labels.awards]
  _join_with_dividers(valid, award => block(breakable: false, {
    let url = award.at("url", default: none)
    [=== #_titled_link(award.title, url)]
    let awarder = award.at("awarder", default: none)
    if _present(awarder) { name[#awarder] }
    let date = award.at("date", default: none)
    if _present(date) { term(_format_date(date, prefs, labels)) }
    let summary = award.at("summary", default: none)
    if _present(summary) { par(summary) }
  }))
}

// Practical subset of JSON Resume's `projects[]`: name, description,
// url, dates, highlights, keywords. `entity`, `type`, `roles` are
// accepted but unrendered (open an issue if you need them). Entries
// without a `name` are skipped to avoid an orphan heading.
#let _projects(entries, labels, prefs) = {
  let valid = entries.filter(p => _present(p.at("name", default: none)))
  if valid.len() == 0 { return }
  [== #labels.projects]
  _join_with_dividers(valid, project => block(breakable: false, {
    let url = project.at("url", default: none)
    [=== #_titled_link(project.name, url)]
    let description = project.at("description", default: none)
    if _present(description) {
      // Softer than `name()` (which is bold + accent) so the
      // description doesn't compete visually with a linked title.
      emph(description)
      linebreak()
    }
    term(_format_date_range(project, labels, prefs))
    for bullet in project.at("highlights", default: ()) [- #bullet]
    _tag_row(project.at("keywords", default: ()))
  }))
}

// Built-in icon hints for common publication `type` strings. The
// lookup is case-insensitive so callers don't need to commit to a
// particular casing; users can extend it via `labels.publicationIcons`
// (e.g. `(Posters: "newspaper")`). Anything not matched here falls back
// to the generic `file` icon — same behaviour as before the type-icon
// mapping was added.
#let _default_publication_icons = (
  articles: "newspaper",
  article: "newspaper",
  "blog posts": "newspaper",
  "blog post": "newspaper",
  books: "book",
  book: "book",
  talks: "microphone",
  talk: "microphone",
  presentations: "microphone",
  presentation: "microphone",
  "conference papers": "newspaper",
  "conference paper": "newspaper",
  papers: "newspaper",
  paper: "newspaper",
)

// `pub.type` is a local extension. The grouping key is rendered
// verbatim as the subheading, so localisers either override
// `labels.articles` (the default for untyped entries) or pre-translate
// the `type` strings. Groups render in first-occurrence order — Typst
// dicts preserve insertion order. Each group's subheading carries a
// type-appropriate icon resolved from `labels.publicationIcons` first,
// then the built-in `_default_publication_icons`, with `file` as the
// final fallback.
#let _publications(pubs, labels, prefs) = if pubs.len() > 0 {
  context {
    let body-size = _body_size_state.get()
    let groups = (:)
    for pub in pubs {
      let key = pub.at("type", default: labels.articles)
      groups.insert(key, groups.at(key, default: ()) + (pub,))
    }
    [== #labels.publications]
    for (group, items) in groups.pairs() [
      #let user-icons = labels.at("publicationIcons", default: (:))
      #let lookup-key = lower(group)
      #let group-icon = user-icons.at(
        group,
        default: user-icons.at(
          lookup-key,
          default: _default_publication_icons.at(lookup-key, default: "file"),
        ),
      )
      ==== #icon(group-icon, size: 1.2 * body-size, shift: 0pt) #group

      #for pub in items [
        #block(breakable: false)[
          #let date = pub.at("releaseDate", default: none)
          #let url = pub.at("url", default: none)
          #let title = pub.at("name", default: "")
          #let publisher = pub.at("publisher", default: none)
          #let summary = pub.at("summary", default: none)
          - #_titled_link(title, url, fallback: emph(title)).
            #if publisher != none [\ #text(0.85 * body-size, fill: _body_colour, publisher)]
            #if date != none [\ #text(0.8 * body-size, fill: _body_colour.lighten(35%), _format_date(date, prefs, labels))]
            #if _present(summary) [\ #par(summary)]
        ]
      ]
    ]
  }
}

// Renders the auto footer: `basics.name` flush left, "Page N / M"
// flush right, both in body colour at 0.8em. Suppressed on
// single-page documents so the common one-page case stays clean —
// the page-count check is reactive (the counter resolves to the
// final value after layout), so adding content that pushes onto a
// second page brings the footer with it without any caller change.
#let _auto_page_footer(name) = context {
  let total = counter(page).final().first()
  if total <= 1 { return }
  let body-size = _body_size_state.get()
  set text(0.8 * body-size, fill: _body_colour)
  grid(
    columns: (1fr, auto),
    align: (left, right),
    name,
    [Page #counter(page).display() / #total],
  )
}

// ─── Section catalogue + default preferences ────────────────────────
//
// Single source of truth for dispatch, default render order, and
// default column membership. Adding an entry here places the section
// in the default layout — still need to write the renderer and add a
// `labels` key. Defined after the renderers because Typst binds
// closure identifiers eagerly.
#let _sections = (
  work: (
    column: "left",
    render: (cv, labels, prefs) => _experience(cv.at("work", default: ()), labels, prefs),
  ),
  volunteer: (
    column: "left",
    render: (cv, labels, prefs) => _volunteer(cv.at("volunteer", default: ()), labels, prefs),
  ),
  focusAreas: (
    column: "right",
    render: (cv, labels, prefs) => _focus_areas(cv.at("focusAreas", default: ()), labels),
  ),
  skills: (
    column: "right",
    render: (cv, labels, prefs) => _skills(cv.at("skills", default: ()), labels),
  ),
  languages: (
    column: "right",
    render: (cv, labels, prefs) => _languages(cv.at("languages", default: ()), labels),
  ),
  education: (
    column: "right",
    render: (cv, labels, prefs) => _education(cv.at("education", default: ()), labels, prefs),
  ),
  certificates: (
    column: "right",
    render: (cv, labels, prefs) => _certificates(
      cv.at("certificates", default: ()),
      labels,
      group: prefs.groupCertificates,
    ),
  ),
  awards: (
    column: "right",
    render: (cv, labels, prefs) => _awards(cv.at("awards", default: ()), labels, prefs),
  ),
  projects: (
    column: "left",
    render: (cv, labels, prefs) => _projects(cv.at("projects", default: ()), labels, prefs),
  ),
  publications: (
    column: "left",
    render: (cv, labels, prefs) => _publications(cv.at("publications", default: ()), labels, prefs),
  ),
  interests: (
    column: "right",
    render: (cv, labels, prefs) => _interests(cv.at("interests", default: ()), labels),
  ),
)

// Defaults derived from `_sections` so adding a section there
// automatically places it in the default layout for its declared
// column. Insertion order in `_sections` controls render order.
#let _keys_for_column(col) = _sections.keys().filter(k => _sections.at(k).column == col)
#let _default_left_column_sections = _keys_for_column("left")
#let _default_right_column_sections = _keys_for_column("right")

// User-facing reference for these prefs lives in the README. Comments
// below capture only what isn't recoverable from the key name + default
// — non-obvious constraints, footguns, and design rationale.
#let _default_preferences = (
  // Must be installed on the build host (CI installs Lato).
  font: "Lato",
  // Every spacing token is an em-multiplier of this, so changing one
  // knob scales the whole document proportionally.
  bodySize: 10pt,
  paper: "a4",
  margin: (x: 0.9cm, y: 1.5cm),
  // `palettes.teal` — see the `palettes` dict for the curated set
  // (`teal`, `navy`, `crimson`, `forest`, `plum`, `charcoal`).
  accent: palettes.teal,
  groupCertificates: true,
  imageSize: 6em,
  linkContactInfo: true,
  // `{q}` is substituted with the URL-encoded location. A string
  // missing that placeholder panics so a typo is caught up front
  // rather than producing a dead link.
  mapsProvider: maps-providers.google,
  imagePosition: "right",
  // Only consulted when `imagePosition` is "center" — chooses whether
  // the centred portrait stacks above or below the header text block.
  imageStackOrder: "above",
  headerTextAlign: "left",
  // PDF metadata (title / author) stays as-supplied regardless of
  // this flag — see the comment above `set document(...)`.
  uppercaseName: true,
  // When true and `cv.meta.lastModified` is set, render a small
  // "Last updated: <value>" line in the page footer. PDF metadata
  // (date / keywords / description) is populated from `meta` and
  // `basics` independently of this flag.
  lastModifiedFooter: false,
  // Controls how ISO 8601 date strings ("2024", "2024-06", "2024-06-15")
  // are rendered wherever the template surfaces a date. Non-ISO strings
  // (e.g. "Jan 2022", "May 2016 – Jul 2017") pass through verbatim
  // regardless of this setting, so pre-formatted data keeps working.
  //   "long"  — "Jun 2024" / "15 Jun 2024" (month names from labels.months)
  //   "short" — "06/2024"  / "15/06/2024"
  //   "iso"   — passthrough of the original string
  //   closure — (parts) -> str, where parts is (year, month?, day?)
  dateFormat: "long",
  // Fraction in (0, 1] (validated in alta()). Use the complement
  // (`1 - r`) and swap the column-section arrays to invert the layout;
  // exactly 1 collapses the grid to a single full-width column.
  columnRatio: 0.65,
  // `none` (default) — no footer. `"auto"` — name + "Page N / M" on
  // multi-page documents only (single-page stays clean). Any content
  // value — rendered verbatim as the footer on every page.
  pageFooter: none,
  // Sections omitted from BOTH arrays don't render even if their data
  // is present; sections listed in both render twice. Defaults derive
  // from `_sections` so adding a section there places it automatically.
  leftColumnSections: _default_left_column_sections,
  rightColumnSections: _default_right_column_sections,
  // Number of dots on the language fluency scale. Default 5 matches
  // LinkedIn's scale (and the built-in `fluency` string map). Override
  // to suit other scales — CEFR (6: A1–C2), ILR (5), or custom.
  // Fluency strings remain anchored to LinkedIn's 0–5 scale, so callers
  // using a non-5 maxRating must supply numeric `rating` values.
  maxRating: 5,
)

// ─── Main template ───────────────────────────────────────────────────
//
// `cv` follows the JSON Resume schema (see `examples/example.typ`).
// `labels` and `preferences` are partial dicts merged over the
// defaults; unknown keys panic.
#let alta(
  cv,
  labels: (:),
  preferences: (:),
) = {
  let labels = _strict_merge(_default_labels, labels, "labels")
  let preferences = _strict_merge(_default_preferences, preferences, "preferences")
  let column-ratio = preferences.columnRatio
  if type(column-ratio) not in (int, float) or column-ratio <= 0 or column-ratio > 1 {
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
    if "[" not in df and df != "iso" and df not in _named_date_formatters {
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
  let accent = preferences.accent
  let body-size = preferences.bodySize
  _accent_state.update(accent)
  _body_size_state.update(body-size)
  _max_rating_state.update(max-rating)

  // PDF metadata is sourced from `basics` (title, author, description)
  // and the JSON Resume `meta` block (date, keywords). Each field is
  // only set when its source is non-empty — `set document(...)` rejects
  // `none` for `date`, and emitting empty strings for `description` /
  // `keywords` would still write a present-but-empty entry.
  //
  // `uppercaseName` is purely visual — PDF metadata stays canonical.
  let meta = cv.at("meta", default: (:))
  let last-modified-raw = meta.at("lastModified", default: none)
  let doc-date = _parse_iso_datetime(last-modified-raw)
  let doc-keywords = _collect_keywords(cv.at("skills", default: ()))
  let doc-description = cv.basics.at("summary", default: none)
  set document(
    title: cv.basics.name + " --- CV",
    author: cv.basics.name,
    ..(if doc-keywords.len() > 0 { (keywords: doc-keywords) } else { (:) }),
    ..(if _present(doc-description) { (description: doc-description) } else { (:) }),
    ..(if doc-date != none { (date: doc-date) } else { (:) }),
  )
  set text(body-size, font: preferences.font, fill: _body_colour)
  // Resolve the page footer. `pageFooter` is the general mechanism and
  // takes precedence when set; `lastModifiedFooter` is sugar for one
  // specific use case and only applies when `pageFooter` is `none`
  // (its default). Resulting value passed to `set page(...)`:
  //   `none`             — no footer
  //   auto renderer      — name + "Page N / M", multi-page only
  //   verbatim content   — rendered on every page
  let resolved-footer = if page-footer != none {
    if page-footer == "auto" {
      _auto_page_footer(cv.basics.name)
    } else {
      page-footer
    }
  } else if preferences.lastModifiedFooter and _present(last-modified-raw) {
    align(right, text(0.8 * body-size, fill: _body_colour, {
      labels.lastModified
      ": "
      last-modified-raw
    }))
  } else {
    none
  }
  set page(
    paper: preferences.paper,
    margin: preferences.margin,
    footer: resolved-footer,
  )
  set par(leading: 0.55em, spacing: 0.7em)
  set list(
    marker: text(0.85em, "•"),
    indent: 0pt,
    body-indent: 0.4 * body-size,
    spacing: 0.55em,
  )

  // Heading levels map to semantic CV roles:
  //   ==   section title (e.g. Experience)
  //   ===  role / qualification line
  //   ==== sub-grouping (publication type)
  show heading.where(level: 2): it => block(sticky: true)[
    #v(0.6 * body-size)
    #text(1.7 * body-size, fill: accent, weight: "bold", upper(it.body))
    #v(-0.7 * body-size)
    #line(length: 100%, stroke: 2pt + accent)
    #v(0.2 * body-size)
  ]
  show heading.where(level: 3): it => block(
    above: 1.0 * body-size,
    below: 0.8 * body-size,
    sticky: true,
    text(1.2 * body-size, fill: _emphasis_colour, weight: "regular", it.body),
  )
  show heading.where(level: 4): it => block(
    above: 0.6 * body-size,
    below: 0.6 * body-size,
    sticky: true,
    text(1.2 * body-size, fill: _emphasis_colour, weight: "bold", it.body),
  )

  _header(
    cv.basics,
    image-size: preferences.imageSize,
    image-position: preferences.imagePosition,
    image-stack-order: preferences.imageStackOrder,
    header-text-align: preferences.headerTextAlign,
    link-contact-info: preferences.linkContactInfo,
    maps-provider: preferences.mapsProvider,
    uppercase-name: preferences.uppercaseName,
  )
  _summary(cv.basics)

  // The same `_sections` dict that derives the column defaults also
  // gates the overrides, so adding a section stays a single-touch
  // change.
  let validate-column(arr, pref-name) = {
    let unknown = arr.filter(k => k not in _sections)
    if unknown.len() > 0 {
      let quote(k) = "\"" + k + "\""
      panic(
        "Unknown " + pref-name + " key(s): " + unknown.map(quote).join(", ")
          + ". Supported: " + _sections.keys().map(quote).join(", "),
      )
    }
  }
  validate-column(preferences.leftColumnSections, "leftColumnSections")
  validate-column(preferences.rightColumnSections, "rightColumnSections")

  // Section renderers are width-agnostic — they fill their container,
  // so the same renderer works whether dropped into the wide or the
  // narrow column.
  let render-column(keys) = {
    for key in keys {
      let entry = _sections.at(key)
      (entry.render)(cv, labels, preferences)
    }
  }

  // Three layout shapes: full-width merge when columnRatio is 1,
  // left-only when the right side is empty, otherwise the canonical
  // two-column grid.
  //
  // Swapping the column-section arrays and inverting `columnRatio`
  // gives a mirrored layout.
  if column-ratio == 1 {
    render-column(preferences.leftColumnSections + preferences.rightColumnSections)
  } else if preferences.rightColumnSections.len() == 0 {
    render-column(preferences.leftColumnSections)
  } else {
    let gutter = 12pt
    let left-width = column-ratio * 100%
    let right-width = (1 - column-ratio) * 100% - gutter
    grid(
      columns: (left-width, right-width),
      column-gutter: gutter,
      render-column(preferences.leftColumnSections),
      render-column(preferences.rightColumnSections),
    )
  }
}
