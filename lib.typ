// altacv — a two-column CV template for Typst, inspired by LianTze
// Lim's AltaCV LaTeX class (https://github.com/liantze/AltaCV, LPPL).
// Forked from George Honeywood's alta-typst
// (https://github.com/GeorgeHoneywood/alta-typst, MIT, © 2023 George
// Honeywood) and rewritten around a JSON Resume-style data dict, with
// a `preferences` extension point for theme + behaviour toggles and a
// `labels` extension point for i18n / localisation.
//
// Public API:
//   alta(cv, ...config)  — render the document from a cv data dict
//                          (schema follows JSON Resume — see the
//                          example in examples/example.typ).
//   Helpers (icon, name, term, skill, tag, divider, styled-link) are
//   also exported for callers who want to compose custom layouts.
//
// Design tokens (spacing, dot sizes, etc.) are derived from `body-size`
// via em-multipliers, so changing body size scales the document
// proportionally. The few absolute values (page margins, column
// gutter, rule thicknesses) are physical / visual choices independent
// of text size.

// ─── State (set by alta() at render time) ─────────────────────────────
#let _body_size_state = state("alta-body-size", 10pt)
#let _accent_state = state("alta-accent", rgb("#00796B"))

// ─── Internal palette ────────────────────────────────────────────────
// Accent is configurable via alta(); body/emphasis are opinionated.
#let _body_colour = rgb("#666666")
#let _emphasis_colour = rgb("#2E2E2E")
#let _empty_dot_colour = rgb("#c0c0c0")
#let _divider_colour = rgb("#D1D1D1")

// ─── Default labels (English) ────────────────────────────────────────
// All display strings the template emits. Callers can override any
// subset via the `labels` parameter on alta() — supplied keys win, the
// rest fall back to these defaults. Allows translation (Spanish,
// French, German, ...) or local renaming (e.g. "Experience" →
// "Work History") without forking the template.
#let _default_labels = (
  experience: "Experience",
  focusAreas: "Areas of Focus",
  skills: "Skills",
  languages: "Languages",
  education: "Education",
  certifications: "Certifications",
  publications: "Publications",
  awards: "Awards",
  projects: "Projects",
  articles: "Articles",
  present: "Present",
)

// Merge user overrides over defaults, panicking on unknown keys so
// typos in `labels` / `preferences` surface as errors instead of being
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

// Percent-encode a string for use in URL query / path components, per
// RFC 3986. Bytes outside the unreserved set (ALPHA / DIGIT / -._~)
// are emitted as %HH; multi-byte UTF-8 codepoints encode each byte
// separately so accented or non-Latin locations (e.g. "Zürich") round-
// trip correctly.
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

// Vendored icons, split by role. SVGs ship with fill="#666666" baked
// in; icon() swaps it at call time. Utility icons drive the contact
// bar / term row / publication list; network icons are matched to
// basics.profiles[].network entries.
#let _utility_icon_sources = (
  calendar: read("icons/calendar.svg"),
  email: read("icons/email.svg"),
  file: read("icons/file.svg"),
  location: read("icons/location.svg"),
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

// Aliases mapping caller-supplied network names to their canonical
// icon key. Matched after lower-casing the network string.
#let _network_aliases = (
  x: "twitter",
)

// ─── Public helpers ──────────────────────────────────────────────────

// Icon helper. Renders a vendored SVG in a fixed-size box.
//
// All measurements default to body-size-relative values so icons scale
// with the surrounding text.
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

// Company / institution line under a role/education entry.
// Bold in the accent colour.
#let name(body) = context {
  let body-size = _body_size_state.get()
  let accent = _accent_state.get()
  block(
    above: 0pt,
    below: 0.6 * body-size,
    text(weight: "bold", fill: accent, body),
  )
}

// Date + optional location row, rendered as two left-aligned half-width
// boxes — period on the left, location on the right. Either side may
// be omitted (`none`); the box is skipped so undated/unlocated entries
// don't emit a stray icon.
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

// Language / skill row — name on the left, N filled dots on the right.
// Supports fractional ratings (e.g. 1.5 → 1 full + 1 half + 3 empty);
// the half-fill uses a 50%/50% linear gradient for a sharp boundary.
//
// _fluency_rating maps LinkedIn-style fluency labels to dot counts.
// Callers can pass `rating` directly for fractional precision, or
// `fluency` for a named level (rating wins if both are present).
#let _max_rating = 5
#let _fluency_rating = (
  "Native":               5,
  "Bilingual":            5,
  "Full Professional":    4,
  "Professional Working": 3,
  "Limited Working":      2,
  "Elementary":           1,
)
#let _check_rating(rating) = {
  if type(rating) not in (int, float) {
    panic("Rating must be numeric, got: " + repr(rating))
  }
  if rating < 0 or rating > _max_rating {
    panic("Rating out of range: " + repr(rating) + ". Expected 0–" + str(_max_rating) + ".")
  }
  rating
}
#let _resolve_rating(entry) = {
  let rating = entry.at("rating", default: none)
  if rating != none { return _check_rating(rating) }
  let fluency = entry.at("fluency", default: none)
  if fluency != none {
    if type(fluency) == str and fluency in _fluency_rating { return _fluency_rating.at(fluency) }
    panic("Unknown fluency level: " + repr(fluency) + ". Provide a numeric `rating` instead, or use one of: " + _fluency_rating.keys().join(", "))
  }
  panic("Language entry needs either a `rating` (0–" + str(_max_rating) + ") or a `fluency` string.")
}
#let _half_fill(accent) = gradient.linear(
  (accent, 0%),
  (accent, 50%),
  (_empty_dot_colour, 50%),
  (_empty_dot_colour, 100%),
)
#let skill(name, rating) = context {
  let body-size = _body_size_state.get()
  let accent = _accent_state.get()
  let dot-radius = 0.45 * body-size
  let dot-baseline = -0.25 * body-size
  let dot-spacing = 0.4 * body-size

  text(name)
  h(1fr)
  for i in range(1, _max_rating + 1) {
    let fill = if rating >= i {
      accent
    } else if rating > i - 1 {
      _half_fill(accent)
    } else {
      _empty_dot_colour
    }
    box(baseline: dot-baseline, circle(radius: dot-radius, fill: fill))
    if i != _max_rating { h(dot-spacing) }
  }
  [\ ]
}

// Pill tag for skills / certifications.
//
// `label: true` gives a subtly emphasised variant for category labels
// (darker fill, bold text). Useful for distinguishing a group heading
// pill from the items that follow it on the same row.
#let tag(body, label: false) = context {
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
  h(0.25 * body-size)
}

// Dashed grey divider between entries within a section.
#let divider() = context {
  let body-size = _body_size_state.get()
  v(0.3 * body-size)
  line(
    length: 100%,
    stroke: (paint: _divider_colour, thickness: 0.6pt, dash: "dashed"),
  )
  v(0.3 * body-size)
}

// Render each item via `render`, interleaving divider() between
// consecutive items. Trailing divider is suppressed.
#let _join_with_dividers(items, render) = {
  for (i, item) in items.enumerate() {
    render(item)
    if i < items.len() - 1 { divider() }
  }
}

// Accented underlined italic link — used for publication titles.
#let styled-link(dest, content) = context {
  let accent = _accent_state.get()
  emph(text(fill: accent, link(dest, content)))
}

// ─── Section renderers (internal) ────────────────────────────────────
//
// Each takes the relevant slice of the cv dict and emits the
// corresponding rendered section. Kept private to the module so the
// public API surface stays small.

// Returns content for the date range, or `none` when neither date is
// supplied (so callers can skip emitting the term row entirely instead
// of falsely rendering "Present" for a fully undated entry).
#let _format_date_range(entry, labels) = {
  let is-empty(v) = v == none or v == ""
  let start = entry.at("startDate", default: none)
  let end = entry.at("endDate", default: none)
  if is-empty(start) and is-empty(end) { return none }
  let end-text = if is-empty(end) { labels.present } else { end }
  if is-empty(start) { [#end-text] } else { [#start – #end-text] }
}

// Circular photo for the header. Source can be a string path
// (resolved relative to lib.typ, so callers should prefer a leading
// "/" for a root-relative path) OR bytes loaded by the caller via
// `read("path", encoding: none)`. Cropping to a circle is achieved
// with a clipped box of `radius: 50%`; the image fills via
// `fit: "cover"` so non-square sources don't distort.
#let _portrait(source, size) = box(
  width: size,
  height: size,
  clip: true,
  radius: 50%,
  image(source, fit: "cover", width: 100%, height: 100%),
)

// Channels the contact bar emits. The order doesn't matter here —
// the per-channel link config is keyed by channel name.
#let _contact_channels = ("email", "phone", "location", "profiles")

// Resolve `linkContactInfo` (bool or partial dict) to a fully-populated
// per-channel dict: `(email: bool, phone: bool, location: bool,
// profiles: bool)`. A bool applies uniformly; a dict overrides the
// listed channels and leaves the rest at the all-linked default.
// Unknown channel keys panic; non-bool / non-dict values panic.
#let _resolve_link_config(value) = {
  let defaults = (email: true, phone: true, location: true, profiles: true)
  if type(value) == bool {
    (email: value, phone: value, location: value, profiles: value)
  } else if type(value) == dictionary {
    let unknown = value.keys().filter(k => k not in _contact_channels)
    if unknown.len() > 0 {
      let quote(k) = "\"" + k + "\""
      panic(
        "Unknown linkContactInfo channel(s): " + unknown.map(quote).join(", ")
          + ". Supported: " + _contact_channels.map(quote).join(", "),
      )
    }
    defaults + value
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
  header-text-align: "left",
  link-contact-info: true,
) = {
  if image-position not in ("left", "right") {
    panic("imagePosition must be \"left\" or \"right\", got: " + repr(image-position))
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
        text(2.5 * body-size, fill: accent, weight: "bold", upper(basics.name)),
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

      // Build the contact bar: email, phone, location (from basics
      // top-level), then any profiles (LinkedIn, Medium, etc.).
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
      let location = basics.at("location", default: none)
      if location != none {
        entries.push((
          channel: "location",
          icon: "location",
          value: location,
          url: "https://www.google.com/maps?q=" + _url_encode(location),
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

      entries
        .map(entry => {
          bar-icon(entry.icon)
          let value = [#entry.value]
          if link-config.at(entry.channel) and entry.url != none {
            link(entry.url, value)
          } else { value }
        })
        .join(h(1.2 * body-size))
      // Paragraph break before _summary; inherits par.spacing so the
      // gap stays in sync with the rest of the document.
      parbreak()
    })

    let image-src = basics.at("image", default: none)
    let has-image = image-src != none and image-src != "" and image-src != bytes(())
    if has-image {
      // Two-column layout: portrait sits in its `auto` column, text
      // fills the remaining `1fr`. Swapping the column order moves
      // the photo to the opposite side without touching the
      // alignment of the text within its column.
      let photo = _portrait(image-src, image-size)
      if image-position == "left" {
        grid(
          columns: (auto, 1fr),
          align: top,
          column-gutter: 1em,
          photo,
          header-text,
        )
      } else {
        grid(
          columns: (1fr, auto),
          align: top,
          column-gutter: 1em,
          header-text,
          photo,
        )
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

#let _experience(work, labels) = if work.len() > 0 [
  == #labels.experience

  #_join_with_dividers(work, job => [
    #block(breakable: false)[
      === #job.position
      #name[#job.name]
      #term(_format_date_range(job, labels), location: job.at("location", default: none))

      #for bullet in job.at("highlights", default: ()) [- #bullet]
    ]
  ])
]

#let _focus_areas(items, labels) = if items.len() > 0 [
  == #labels.focusAreas

  #for item in items [- #item]
]

// Group name renders as the leftmost pill, styled distinctly so it
// reads as a category, with a "-" separator between the label and the
// items. tag()'s trailing h(...) gives space before the dash; the
// h(...) below balances the gap on the right. text("-") rather than
// `[-]` so Typst doesn't parse the hyphen as a list-item bullet.
#let _skills(groups, labels) = if groups.len() > 0 {
  context {
    let body-size = _body_size_state.get()
    let row-gap = 0.7 * body-size
    [== #labels.skills]
    for group in groups {
      let keywords = group.at("keywords", default: ())
      if keywords.len() == 0 { continue }
      block(above: 0pt, below: row-gap, par(hanging-indent: 1em, leading: row-gap, {
        tag(group.name, label: true)
        text("-")
        h(0.25 * body-size)
        for item in keywords { tag(item) }
      }))
    }
  }
}

#let _languages(items, labels) = if items.len() > 0 [
  == #labels.languages

  #_join_with_dividers(items, lang => block(
    breakable: false,
    skill(lang.language, _resolve_rating(lang)),
  ))
]

#let _education(entries, labels) = if entries.len() > 0 [
  == #labels.education

  #_join_with_dividers(entries, edu => [
    #block(breakable: false)[
      #let title = edu.at("studyType", default: edu.at("area", default: ""))
      #if title != "" [=== #title]
      #name[#edu.at("institution", default: "")]
      #term(_format_date_range(edu, labels))

      #if "score" in edu and edu.score != none [#edu.score]
    ]
  ])
]

// Bucket certs by issuer (insertion order preserved), then split into
// multi-issuer groups + a trailing pool of singletons. Returns an
// array of arrays of cert names — the issuer key is only used for
// grouping and never rendered.
#let _build_cert_groups(certs) = {
  let by-issuer = (:)
  for cert in certs {
    let issuer = cert.at("issuer", default: "")
    let name = cert.at("name", default: "")
    if name == "" { continue }
    by-issuer.insert(issuer, by-issuer.at(issuer, default: ()) + (name,))
  }
  let groups = ()
  let singletons = ()
  for (_, names) in by-issuer.pairs() {
    if names.len() > 1 { groups.push(names) } else { singletons.push(names.first()) }
  }
  if singletons.len() > 0 { groups.push(singletons) }
  groups
}

#let _certificates(certs, labels, group: true) = if certs.len() > 0 {
  let groups = if group {
    _build_cert_groups(certs)
  } else {
    (certs.map(c => c.at("name", default: "")).filter(n => n != ""),)
  }
  [== #labels.certifications]
  _join_with_dividers(groups, names => block(
    breakable: false,
    { for n in names [#tag(n)] },
  ))
}

// True when `v` is a meaningfully-present value — neither `none`, an
// empty string `""`, nor an empty content block `[]`. Used by section
// renderers to skip entries whose required field is effectively
// absent (key missing, explicit nil, or empty templated content).
#let _present(v) = v != none and v != "" and v != []

// Awards / honours section. Each entry follows the JSON Resume
// `awards[]` schema: title (required), date, awarder, summary. The
// awarder reads as a subtitle (in the accent colour, like education's
// institution row); the date row goes through `term()`; the summary
// renders as a paragraph below. `summary` is treated as content
// (string or `[ ... ]` markup) and passed verbatim to `par()`.
// Entries without a `title` are skipped to avoid an orphan empty
// heading.
#let _awards(entries, labels) = {
  let valid = entries.filter(a => _present(a.at("title", default: none)))
  if valid.len() == 0 { return }
  [== #labels.awards]
  _join_with_dividers(valid, award => block(breakable: false, {
    [=== #award.title]
    let awarder = award.at("awarder", default: none)
    if _present(awarder) { name[#awarder] }
    let date = award.at("date", default: none)
    if _present(date) { term(date) }
    let summary = award.at("summary", default: none)
    if _present(summary) { par(summary) }
  }))
}

// Projects section. Each entry follows the JSON Resume `projects[]`
// schema (the practical subset: name, description, url, startDate /
// endDate, highlights, keywords). The name links to `url` when
// supplied. Keywords render as a row of pill tags below the highlights.
// Entries without a `name` are skipped (matches the empty-cert-name
// behaviour in `_build_cert_groups`) so a stray entry doesn't emit
// an orphan empty heading.
#let _projects(entries, labels) = {
  let valid = entries.filter(p => _present(p.at("name", default: none)))
  if valid.len() == 0 { return }
  [== #labels.projects]
  _join_with_dividers(valid, project => block(breakable: false, {
    let title = project.name
    let url = project.at("url", default: none)
    [=== #if url != none { styled-link(url, title) } else { title }]
    let description = project.at("description", default: none)
    if _present(description) {
      // Softer than `name()` (which is bold + accent) so the
      // description doesn't compete visually with a linked title.
      emph(description)
      linebreak()
    }
    term(_format_date_range(project, labels))
    for bullet in project.at("highlights", default: ()) [- #bullet]
    let keywords = project.at("keywords", default: ())
    if keywords.len() > 0 {
      for kw in keywords { tag(kw) }
    }
  }))
}

// Group publications by `pub.type` (a local extension to JSON Resume).
// Entries without `type` fall under `labels.articles` so a CV of plain
// blog posts renders as before. The grouping key is used verbatim as
// the subheading, so users localising the section can either override
// `labels.articles` (for the default) or supply already-translated
// `type` strings directly. Typst dicts preserve insertion order, so
// groups render in first-occurrence order.
#let _publications(pubs, labels) = if pubs.len() > 0 {
  context {
    let body-size = _body_size_state.get()
    let groups = (:)
    for pub in pubs {
      let key = pub.at("type", default: labels.articles)
      groups.insert(key, groups.at(key, default: ()) + (pub,))
    }
    [== #labels.publications]
    for (group, items) in groups.pairs() [
      ==== #icon("file", size: 1.2 * body-size, shift: 0pt) #group

      #for pub in items [
        #block(breakable: false)[
          #let date = pub.at("releaseDate", default: none)
          #let url = pub.at("url", default: none)
          #let title = pub.at("name", default: "")
          - #if date != none [#text(0.8 * body-size, fill: _body_colour.lighten(35%), date) \ ]
            #if url != none { styled-link(url, title) } else { emph(title) }.
        ]
      ]
    ]
  }
}

// ─── Section catalogue + default preferences ────────────────────────
// Canonical list of every section the template supports. Each entry
// pairs a section name with the column it lands in by default plus a
// render closure that takes the runtime context (cv / labels /
// preferences) and returns the rendered content.
//
// On the column-layout side this is the single source of truth: the
// dispatch lookup, default render order, and default column
// membership are all derived from this dict, so a new section can't
// be silently dropped from the default layout by forgetting to add
// it to a parallel order array.
//
// Adding a new section is still three touches across the file —
// the renderer function (e.g. `_awards`), a label key in
// `_default_labels`, and an entry here — but the layout-side
// drift risk is gone.
//
// Typst dicts preserve insertion order, which controls the default
// render order within each column. Defined after the section
// renderers because Typst closures bind identifiers eagerly at
// creation time.
#let _sections = (
  work: (
    column: "left",
    render: (cv, labels, prefs) => _experience(cv.at("work", default: ()), labels),
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
    render: (cv, labels, prefs) => _education(cv.at("education", default: ()), labels),
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
    render: (cv, labels, prefs) => _awards(cv.at("awards", default: ()), labels),
  ),
  projects: (
    column: "right",
    render: (cv, labels, prefs) => _projects(cv.at("projects", default: ()), labels),
  ),
  publications: (
    column: "right",
    render: (cv, labels, prefs) => _publications(cv.at("publications", default: ()), labels),
  ),
)

// Defaults derived from `_sections` so adding a section there
// automatically places it in the default layout for its declared
// column. Insertion order in `_sections` controls render order.
#let _keys_for_column(col) = _sections.keys().filter(k => _sections.at(k).column == col)
#let _default_left_column_sections = _keys_for_column("left")
#let _default_right_column_sections = _keys_for_column("right")

#let _default_preferences = (
  // Primary font family. Must be installed on the build host.
  font: "Lato",
  // Base text size; every sub-element scales from this via em
  // multipliers, so changing it scales the document proportionally.
  bodySize: 10pt,
  // Standard paper size. Passed to `set page(paper: ...)`, which
  // resolves names like "a4" (210×297mm — default), "us-letter"
  // (8.5×11"), "a5", "us-legal", etc. into page dimensions. See
  // https://typst.app/docs/reference/layout/page/#parameters-paper.
  paper: "a4",
  // Page margins. Anything `set page(margin: ...)` accepts works.
  margin: (x: 0.9cm, y: 1.5cm),
  // Theme colour applied to headings, accent rules, tag borders and
  // skill-dot fills.
  accent: rgb("#00796B"),
  // When true, certificates are grouped by issuer (issuers with 2+
  // certs become their own group; singletons pool into a final "other"
  // group). When false, certificates render as a single flat row.
  groupCertificates: true,
  // Diameter of the circular portrait when `basics.image` is set.
  // The image is clipped to a circle of this size. Ignored when
  // `basics.image` is absent.
  imageSize: 6em,
  // Controls whether contact-bar entries are wrapped in deep links
  // (mailto: for email, tel: for phone, a Google Maps search URL for
  // location, the supplied URL for profiles). Accepts either:
  //
  //   - a boolean — applies to every channel uniformly:
  //       linkContactInfo: true    (default; everything linked)
  //       linkContactInfo: false   (icons + plain text, no links)
  //   - a partial dict keyed by channel — listed channels override,
  //     omitted channels stay linked:
  //       linkContactInfo: (phone: false)
  //       linkContactInfo: (email: false, location: false)
  //
  // Valid channel keys: "email", "phone", "location", "profiles".
  // Unknown channel keys panic; non-bool / non-dict values panic.
  linkContactInfo: true,
  // Side of the header the portrait sits on: "left" or "right".
  // Ignored when `basics.image` is absent.
  imagePosition: "right",
  // Horizontal alignment of the text content (name, label, contact
  // bar) within its column. One of "left", "right", "center".
  // Default "left" keeps every line starting at a consistent edge
  // for natural left-to-right reading regardless of which side the
  // photo is on; set "right" or "center" for a mirrored or
  // centred header look.
  headerTextAlign: "left",
  // Left-column width as a fraction of the page (between 0 and 1
  // exclusive). The right column gets the remainder minus a fixed
  // gutter. Default (0.64) gives the historic experience-left /
  // side-panel-right split a little more left-column room; flipping
  // to ~0.36 with swapped column-sections inverts the layout.
  columnRatio: 0.64,
  // Sections to render in the left column, in order. Each key must
  // be one of the names declared in `_sections`. Sections omitted
  // from BOTH `leftColumnSections` and `rightColumnSections` are
  // not rendered even if their data is present; sections listed in
  // both render twice. Unknown keys panic. Default derives from
  // `_sections` (everything with `column: "left"`).
  leftColumnSections: _default_left_column_sections,
  // Sections to render in the right column, in order. Same key set
  // and validation as `leftColumnSections`. Default derives from
  // `_sections` (everything with `column: "right"`).
  rightColumnSections: _default_right_column_sections,
)

// ─── Main template ───────────────────────────────────────────────────
//
// alta(cv, ...config) renders the document from a cv data dict.
//
// Parameters:
//   cv          — data dict; see examples/example.typ for the schema
//                 (follows JSON Resume — https://jsonresume.org/).
//   labels      — partial dict overriding the template's English
//                 display strings (section headings, "Present" date
//                 literal). Supply only the keys you want to change;
//                 the rest fall back to _default_labels.
//   preferences — partial dict of theme / font / layout / behaviour
//                 toggles. Supply only the keys you want to change;
//                 the rest fall back to _default_preferences. See
//                 that dict for the full set: font, bodySize, paper,
//                 margin, accent, groupCertificates, imageSize,
//                 imagePosition, headerTextAlign, columnRatio,
//                 leftColumnSections, rightColumnSections.
#let alta(
  cv,
  labels: (:),
  preferences: (:),
) = {
  let labels = _strict_merge(_default_labels, labels, "labels")
  let preferences = _strict_merge(_default_preferences, preferences, "preferences")
  let column-ratio = preferences.columnRatio
  if type(column-ratio) not in (int, float) or column-ratio <= 0 or column-ratio >= 1 {
    panic("columnRatio must be a number strictly between 0 and 1, got: " + repr(column-ratio))
  }
  let accent = preferences.accent
  let body-size = preferences.bodySize
  _accent_state.update(accent)
  _body_size_state.update(body-size)

  set document(title: cv.basics.name + " --- CV", author: cv.basics.name)
  set text(body-size, font: preferences.font, fill: _body_colour)
  set page(paper: preferences.paper, margin: preferences.margin)
  set par(leading: 0.55em, spacing: 0.7em)
  set list(
    marker: text(0.85em, "•"),
    indent: 0pt,
    body-indent: 0.4 * body-size,
    spacing: 0.55em,
  )

  // Section heading (==): bold uppercase in accent + 2pt rule.
  show heading.where(level: 2): it => block(sticky: true)[
    #v(0.6 * body-size)
    #text(1.7 * body-size, fill: accent, weight: "bold", upper(it.body))
    #v(-0.7 * body-size)
    #line(length: 100%, stroke: 2pt + accent)
    #v(0.2 * body-size)
  ]
  // Role / qualification line (===): emphasis colour, regular weight.
  show heading.where(level: 3): it => block(
    above: 1.0 * body-size,
    below: 0.8 * body-size,
    sticky: true,
    text(1.2 * body-size, fill: _emphasis_colour, weight: "regular", it.body),
  )
  // Subsection (====): bold in emphasis colour.
  show heading.where(level: 4): it => block(
    above: 0.6 * body-size,
    below: 0.6 * body-size,
    sticky: true,
    text(1.2 * body-size, fill: _emphasis_colour, weight: "bold", it.body),
  )

  // Header (name / label / contact bar) + summary.
  _header(
    cv.basics,
    image-size: preferences.imageSize,
    image-position: preferences.imagePosition,
    header-text-align: preferences.headerTextAlign,
    link-contact-info: preferences.linkContactInfo,
  )
  _summary(cv.basics)

  // Validate both column arrays against the canonical section set
  // declared in module-scope `_sections`. Unknown keys panic with the
  // supported set; the same single source of truth that derives the
  // defaults also gates the overrides.
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

  // Render the given section keys in order. The section renderers
  // themselves are width-agnostic (they fill their container), so the
  // same section adapts to whichever column it ends up in.
  let render-column(keys) = {
    for key in keys {
      let entry = _sections.at(key)
      (entry.render)(cv, labels, preferences)
    }
  }

  // Two-column body via grid. `preferences.columnRatio` controls
  // the split width, so swapping the section arrays and adjusting
  // `columnRatio` together gives an inverted layout.
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
