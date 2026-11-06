// The building blocks for a CV written in markup inside the `altacv`
// template (#370): what Typst has no element for, over the components
// `alta()` draws with. Re-exported from `lib.typ`.

#import "data/defaults.typ": (
  _default-labels, _default-preferences, _translations,
)
#import "data/cv.typ": (
  _authors, _entry-period, _identifier-refs, _identifier-url, _identifiers,
  _owner-keys, _skill-rating,
)
#import "design/icon-set.typ": _icon-glyphs, _network-icons
#import "icons.typ": _check-icon
#import "data/validation.typ": _preference-rules
#import "util/checks.typ": (
  _check, _check-rating, _check-type, _dict-rule, _enum-rule, _list-rule,
  _positive-int-rule,
)
#import "context.typ": _max-rating-state
#import "primitives.typ": _divider, _portrait
#import "components/bibliography.typ": _bib-entry
#import "components/entry.typ": _entry
#import "components/header.typ": _page-header
#import "components/keywords.typ": _keyword-rows, _label-rows
#import "components/ratings.typ": _rating-mark

// The labels in the document's language, as `alta()` resolves them:
// its bundled translation over the English. A shallow merge, not
// `_merge-options` per call: the blocks read only top-level labels
// (`date`, `location`), which it resolves exactly.
#let _labels() = _default-labels + _translations.at(text.lang, default: (:))

// The most recent section or group heading before here: the heading
// an entry sits under. Entries' own headings don't count.
#let _parent-heading() = (
  query(selector(heading).before(here()))
    .filter(h => h.at("label", default: none) != <alta-internal-entry>)
    .at(-1, default: none)
)

/// An entry: a role, a qualification, a project. Its facts are named
/// arguments; its prose (a list of highlights) is the body.
/// Its heading sits one level below the section or group before it, and
/// the theme's divider separates it from the entry before it in the
/// same section or group. It needs a section (`=`) or group (`==`)
/// heading before it. One right after `#alta(cv)` continues `alta()`'s
/// last section, after a divider, so start your own with `= ...`.
/// An entry doesn't break across pages: it moves to the next whole,
/// and one taller than a page overflows it, so split long prose over
/// several entries.
///
/// - title (content, str, none): The role or qualification.
/// - url (str, none): A link for the title.
/// - org (content, str, none): The organisation, in the accent.
/// - org-url (str, none): A link for the organisation.
/// - subtitle (array): A small line under the heading (a referee's
///   attribution): groups of facts, an array of arrays, the facts in a
///   group joined by the theme's item separator and the groups by its
///   fact separator: `(("Manager", "Acme"), ("2024",))`.
/// - roles (array): Further roles, after the organisation.
/// - date (content, str, array, none): At the right edge. Content or
///   a string shows as written; a `(start, end)` pair as `alta()`
///   shows a period: the two joined by the theme's range separator, a
///   `none` end reading the document language's "Present", a `none`
///   start leaving the end alone; `(none, none)` shows nothing.
/// - location (content, str, none): Under the date.
/// - details (array): Short facts after the roles (a credential ID).
/// - summary (content, str, none): A short summary, set apart (italic
///   by default) before the body, as `alta()` sets a `summary`.
/// - keywords-lead (array): A line of its own above the keywords
///   (education's area and score), so it doesn't read as one of them:
///   groups of facts, as `subtitle` takes.
/// - keywords (array): A line of keywords ending the entry.
/// - body (content): The highlights, or any other prose.
/// -> content
#let entry(
  title: none,
  url: none,
  org: none,
  org-url: none,
  subtitle: (),
  roles: (),
  date: none,
  location: none,
  details: (),
  summary: none,
  keywords-lead: (),
  keywords: (),
  body,
) = context {
  if type(date) == array and date.len() != 2 {
    panic(
      "entry() date takes one date or a `(start, end)` pair, got "
        + str(date.len())
        + " dates",
    )
  }
  let parent = _parent-heading()
  if parent == none {
    panic(
      "entry() needs a section heading (`= Experience`) or a group heading (`== Talks`) before it",
    )
  }
  // The template styles an entry's heading at level 2 or 3 only.
  if parent.level >= 3 {
    panic(
      "entry() sits under `=` sections and `==` groups; a `===` heading isn't styled as either",
    )
  }
  // Every entry before here under the same heading, by the mark
  // `_entry` leaves on each, titled or not: `alta()`'s too, so one
  // after `#alta(cv)` continues its last section.
  let siblings = selector(<alta-internal-entry-mark>)
    .before(here())
    .after(parent.location())
  // `alta()` joins a section's entries with the divider, so none
  // precedes the first of a section or group. The divider sits in the
  // entry's unbreakable block, so an entry pushed to the next page
  // takes it along rather than leaving a rule at the page's foot.
  // At a page top the divider keeps its space, the rule hidden, where
  // `alta()`'s drops both: dropping it moved what follows, which moved
  // the next divider, and a CV of a few pages ran out of Typst's five
  // layout passes. Hidden, it moves nothing.
  let labels = _labels()
  block(breakable: false, {
    if query(siblings).len() > 0 { _divider(true, at-top: hide) }
    _entry(
      // The icons' alt text, in the document's language.
      labels,
      title: title,
      url: url,
      org: org,
      org-url: org-url,
      subtitle: subtitle,
      roles: roles,
      // A pair as `alta()` reads a period, its open end the language's
      // "Present"; else one side, as written: `_range` joins only the
      // present sides.
      period: if type(date) == array {
        let (start, end) = date
        _entry-period(
          (start-date: start, end-date: end),
          d => d,
          labels.present,
        )
      } else { (date,) },
      location: (location,),
      details: details,
      summary: summary,
      body: body,
      keywords-lead: keywords-lead,
      keywords: keywords,
      level: parent.level + 1,
    )
  })
}

// Content's text, for alt text, which takes a string: `document.title`
// is content, `[Jane Doe]` set from a string. One case per kind of
// element, the first that matches returning.
#let _plain(it) = {
  if type(it) == str { return it }
  if it.has("text") { return _plain(it.text) }
  if it.has("children") { return it.children.map(_plain).join(default: "") }
  if it.has("body") { return _plain(it.body) }
  if it.func() == smartquote { return if it.double { "\"" } else { "'" } }
  if it.func() in ([ ].func(), linebreak) { return " " }
  // A gap (`h(0.3em)`, `h(1fr)`) reads as a space; a negative kern,
  // pulling its neighbours together, as nothing.
  if it.func() == h {
    let a = it.amount
    let gap = if type(a) == fraction { a > 0fr } else {
      let r = 0% + 0pt + a
      r.ratio > 0% or r.length.abs > 0pt or r.length.em > 0
    }
    return if gap { " " } else { "" }
  }
  ""
}

// An `auto` contact alt, as `alta()`'s contacts read: a profile its
// network, a location the localised word, and email, phone and a
// homepage (`link`) nothing, their text saying what they are.
#let _contact-alt(icon, labels) = if icon == "location" {
  labels.location
} else if icon in _network-icons and icon != "link" { icon }

/// One contact-bar entry for `cv-header`: an icon, its text, and an
/// optional link.
///
/// - icon (str): A key of the icon set (`icon()`'s names: `"email"`,
///   `"phone"`, `"github"`, …).
/// - value (content, str): The text shown.
/// - link (str, none): Where it links (`mailto:…`, a URL).
/// - alt (str, none, auto): Read aloud before it. `auto` reads as
///   `alta()`'s contacts do: a profile network's icon (`"github"`) its
///   name, `"location"` the localised word for it, and the rest
///   (`"email"`, `"phone"`, `"link"`), whose text says what it is,
///   nothing.
/// -> dictionary
#let contact(icon, value, link: none, alt: auto) = {
  // `icon()`'s check, so an unknown name panics the same way.
  _check-icon("contact() icon", icon)
  // `_contact-bar`'s record; `icon` resolves an `auto` alt in context
  // (`cv-header`, `_contact-alt`), where the document's language is
  // known.
  (icon: icon, glyph: _icon-glyphs.at(icon), value: value, url: link, alt: alt)
}

/// The CV's header: your name (rendered with Typst's `title`
/// element), a tagline, an objective, the contact bar, and an optional
/// portrait and QR code. Its text follows the surrounding alignment:
/// `#align(center, cv-header(..))` centres it.
///
/// - name (auto, content, str): Your name. `auto` is the document's
///   title (`#set document(title: ..)`).
/// - tagline (content, str, none): Under the name.
/// - objective (content, str, none): A short goal, under the tagline.
/// - contacts (array): `contact(..)` entries, wrapping as one row of
///   the contact bar. A `linebreak()` among them starts a new row, as
///   `alta()` sets its profiles under the other details
///   (`adapter.basics-contacts` returns them so).
/// - photo (content, none): The portrait: content, typically an
///   `image(..)`, loaded in your file, so its path is yours.
/// - photo-side (alignment): `left`, `right`, `top` or `bottom`.
/// - photo-size (auto, length, ratio, relative): The portrait's side.
///   `auto` is `alta()`'s default `image-size`.
/// - photo-shape (auto, str): The portrait's frame: `"circle"`,
///   `"rounded"` or `"square"`. `auto` is `alta()`'s default
///   `image-shape`.
/// - qr (str, none): A URL to encode as a QR code, opposite the photo.
/// - uppercase (bool): Set the name in capitals.
/// -> content
#let cv-header(
  name: auto,
  tagline: none,
  objective: none,
  contacts: (),
  photo: none,
  photo-side: right,
  photo-size: auto,
  photo-shape: auto,
  qr: none,
  uppercase: true,
) = {
  _check-type(
    "cv-header() name",
    name,
    (content, str, type(auto)),
    "content, a string or auto",
  )
  _check("cv-header() photo-side", photo-side, _enum-rule((
    left,
    right,
    top,
    bottom,
  )))
  _check-type(
    "cv-header() photo",
    photo,
    (content, type(none)),
    "content or none",
  )
  // The photo's `key` (`size`, `shape`): `auto` reads `alta()`'s
  // default `image-{key}`, anything else is checked as that preference.
  let photo-option(key, value) = if value == auto {
    _default-preferences.at("image-" + key)
  } else {
    _check(
      "cv-header() photo-" + key,
      value,
      _preference-rules.at("image-" + key),
    )
    value
  }
  let photo-size = photo-option("size", photo-size)
  let photo-shape = photo-option("shape", photo-shape)
  context {
    let name = if name != auto { name } else { document.title }
    if name == none {
      panic(
        "cv-header() shows the document's title as your name: `#set document(title: \"Jane Doe\")` first, or pass `name:`",
      )
    }
    let labels = _labels()
    _page-header(
      name: name,
      headline: tagline,
      objective: objective,
      // A row per run between `linebreak()`s, each wrapping between
      // entries as `alta()`'s rows do; an empty run, none.
      contacts: contacts
        .split(linebreak())
        .filter(row => row != ())
        .map(row => row.map(c => (
          c
            + (
              alt: if c.alt == auto { _contact-alt(c.icon, labels) } else {
                c.alt
              },
            )
        ))),
      // The surrounding alignment's horizontal part: `start`, unless
      // an `align` around the header says otherwise.
      text-align: align.alignment.x,
      uppercase: uppercase,
      // Framed as `alta()` frames `basics.image`; `alt` is the
      // person's name.
      photo: if photo != none {
        _portrait(photo, photo-size, _plain(name), shape: photo-shape)
      },
      photo-at: photo-side,
      qr-url: qr,
      title: true,
    )
  }
}

/// A publication, as a bibliography item: the title (linked), the
/// authors (yours set apart: the document's author), the source and
/// date, and persistent identifiers. Consecutive publications stack
/// as `alta()`'s do, so a group of them reads as one list.
///
/// - title (content, str): The title.
/// - url (str, none): Its link; with none, the first linkable
///   identifier's (DOI, then arXiv, then PMID), as `alta()` links.
/// - authors (array): Author names (strings or content, shown as
///   their text), in order. The one matching an owner, ignoring case
///   and surrounding spaces, is set apart.
/// - owners (auto, array): The names to set apart among the authors,
///   as `alta()` sets apart the CV's name and `owner-names`. `auto` is
///   the document's author (`#set document(author: ..)`).
/// - source (content, str, none): The publisher or venue.
/// - date (content, str, none): When, as written.
/// - identifiers (dictionary): ID strings by scheme (`doi`, `arxiv`,
///   `pmid` link; others, `isbn` say, show unlinked).
/// - body (content): A summary.
/// -> content
#let publication(
  title: none,
  url: none,
  authors: (),
  owners: auto,
  source: none,
  date: none,
  identifiers: (:),
  body,
) = {
  // `alta()`'s readers are lenient, dropping what they can't read;
  // arguments written by hand panic instead.
  _check(
    "publication() authors",
    authors,
    _list-rule((str, content), "an array of strings or content"),
  )
  _check(
    "publication() identifiers",
    identifiers,
    _dict-rule((str,), "a dictionary of strings"),
  )
  if owners != auto {
    _check(
      "publication() owners",
      owners,
      _list-rule((str,), "auto or an array of strings"),
    )
  }
  context {
    // `alta()`'s readers, over the arguments in its CV shape; an
    // author given as content is matched and shown as its text.
    let refs = _identifier-refs(_identifiers((identifiers: identifiers)))
    // `document.author` is an array of strings: Typst wraps an author
    // set as a string, and leaves it empty when unset.
    let owners = _owner-keys(
      if owners == auto { document.author } else { owners },
    )
    // One unbreakable block per item, as `alta()` lays them out.
    block(breakable: false, _bib-entry(
      title,
      url: if url != none { url } else { _identifier-url(refs) },
      authors: _authors((authors: authors.map(_plain)), owners),
      publisher: source,
      date: date,
      identifiers: refs,
      summary: if body != [] { body },
    ))
  }
}

/// A skill group's row: its name as a label pill, then its keywords as
/// pills, with an optional level: a number or a term such as "Expert"
/// shows as dots, any other text as written.
///
/// - name (content, str): The group's name.
/// - keywords (array): Its keywords, each a pill.
/// - level (int, float, str, content, none): Its level, after the name:
///   a number as that many dots, from 0 to `max` in steps of 0.5, as
///   `alta()` shows a `custom.altacv.rating`; a rating term
///   (`"Beginner"`, `"Intermediate"`, `"Advanced"`, `"Expert"`, …) as
///   its share of `max` dots; anything else as written.
/// - max (auto, int): The dots in the row; `auto` is `rating()`'s: the
///   enclosing `alta()`'s `preferences.max-rating`, else 5.
/// -> content
#let skills(name, keywords, level: none, max: auto) = context {
  let max = if max == auto { _max-rating-state.get() } else { max }
  _check("skills() max", max, _positive-int-rule)
  let numeric = type(level) in (int, float)
  if numeric { _check-rating("skills() level", level, max) }
  _keyword-rows((
    (
      name: name,
      keywords: keywords,
      mark: _rating-mark(
        if numeric { level } else {
          _skill-rating(
            (level: level),
            _default-preferences + (max-rating: max),
          )
        },
        max,
        fallback: level,
      ),
    ),
  ))
}

/// A labelled line: "Music: Trad, Jazz".
///
/// - label (content, str): The label, in the emphasis colour.
/// - items (array): The items, joined by the theme's separator.
/// -> content
#let label-row(label, items) = context block(
  // Rows stack a line apart, as `alta()`'s rows of one paragraph do.
  spacing: par.leading,
  _label-rows(((name: label, keywords: items),)),
)
