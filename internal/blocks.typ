// The building blocks for a CV written in markup inside the `altacv`
// template (#370): what Typst has no element for, over the components
// `alta()` draws with. Re-exported from `lib.typ`.

#import "data/defaults.typ": (
  _default-labels, _default-preferences, _translations,
)
#import "data/cv.typ": (
  _authors, _identifier-refs, _identifier-url, _identifiers, _owner-keys,
  _skill-rating,
)
#import "design/icon-set.typ": _icon-glyphs, _network-icons
#import "icons.typ": _check-icon
#import "util/checks.typ": _check, _check-type, _enum-rule, _list-rule
#import "primitives.typ": _divider, _portrait
#import "components/bibliography.typ": _bib-entry
#import "components/entry.typ": _entry
#import "components/header.typ": _page-header
#import "components/keywords.typ": _keyword-rows, _label-rows
#import "components/ratings.typ": _rating-mark

// The labels in the document's language, as `alta()` resolves them:
// its bundled translation over the English.
#let _labels() = _default-labels + _translations.at(text.lang, default: (:))

// The most recent section or group heading before here: the heading
// an entry sits under. Entries' own headings don't count.
#let _parent-heading() = (
  query(selector(heading).before(here()))
    .filter(h => h.at("label", default: none) != <alta-internal-entry>)
    .at(-1, default: none)
)

/// An entry: a role, a qualification, a project. Its facts are named
/// arguments; its prose (a summary, a list of highlights) is the body.
/// Its heading sits one level below the section or group before it, and
/// the theme's divider separates it from the entry before it in the
/// same section or group. It needs a section (`=`) or group (`==`)
/// heading before it. One right after `#alta(cv)` continues `alta()`'s
/// last section, after a divider, so start your own with `= ...`.
///
/// - title (content, str, none): The role or qualification.
/// - url (str, none): A link for the title.
/// - org (content, str, none): The organisation, in the accent.
/// - org-url (str, none): A link for the organisation.
/// - roles (array): Further roles, after the organisation.
/// - date (content, str, none): The date or range, at the right edge, as written.
/// - location (content, str, none): Under the date.
/// - details (array): Short facts after the roles (a credential ID).
/// - keywords (array): A line of keywords ending the entry.
/// - body (content): The summary and highlights.
/// -> content
#let entry(
  title: none,
  url: none,
  org: none,
  org-url: none,
  roles: (),
  date: none,
  location: none,
  details: (),
  keywords: (),
  body,
) = context {
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
  // Every entry before here under the same heading: this block's
  // markers, which a titleless entry leaves too, and `alta()`'s entry
  // headings, so one after `#alta(cv)` continues its last section.
  let siblings = selector(<alta-internal-entry-mark>)
    .or(<alta-internal-entry>)
    .before(here())
    .after(parent.location())
  // `alta()` joins a section's entries with the divider, so none
  // precedes the first of a section or group. At a page top the
  // divider keeps its space, the rule hidden, where `alta()`'s drops
  // both: dropping it moved what follows, which moved the next
  // divider, and a CV of a few pages ran out of Typst's five layout
  // passes. Hidden, it moves nothing.
  if query(siblings).len() > 0 { _divider(true, at-top: hide) }
  [#metadata(none)<alta-internal-entry-mark>]
  block(breakable: false, _entry(
    // The icons' alt text, in the document's language.
    _labels(),
    title: title,
    url: url,
    org: org,
    org-url: org-url,
    roles: roles,
    // One side, as written: `_range` joins only the present sides.
    period: (date,),
    location: (location,),
    details: details,
    body: body,
    keywords: keywords,
    level: parent.level + 1,
  ))
}

// Content's text, for alt text, which takes a string: `document.title`
// is content, `[Jane Doe]` set from a string.
#let _plain(it) = if type(it) == str { it } else if it.has("text") {
  _plain(it.text)
} else if it.has("children") {
  it.children.map(_plain).join(default: "")
} else if it.has("body") { _plain(it.body) } else if (
  it.func() == smartquote
) { if it.double { "\"" } else { "'" } } else if (
  it.func() == [ ].func()
) { " " } else { "" }

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

/// The CV's header: your name (the document's title, rendered with
/// Typst's `title` element), a tagline, an objective, the contact bar,
/// and an optional portrait and QR code.
///
/// - tagline (content, str, none): Under the name.
/// - objective (content, str, none): A short goal, under the tagline.
/// - contacts (array): `contact(..)` entries, wrapping as one bar.
/// - photo (content, none): The portrait: content, typically an
///   `image(..)`, loaded in your file, so its path is yours.
/// - photo-side (alignment): `left`, `right`, `top` or `bottom`.
/// - qr (str, none): A URL to encode as a QR code, opposite the photo.
/// - uppercase (bool): Set the name in capitals.
/// -> content
#let cv-header(
  tagline: none,
  objective: none,
  contacts: (),
  photo: none,
  photo-side: right,
  qr: none,
  uppercase: true,
) = {
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
  context {
    let name = document.title
    if name == none {
      panic(
        "cv-header() shows the document's title as your name: `#set document(title: \"Jane Doe\")` first",
      )
    }
    let labels = _labels()
    let prefs = _default-preferences
    _page-header(
      name: name,
      headline: tagline,
      objective: objective,
      // One row, wrapping between entries as `alta()`'s rows do.
      contacts: if contacts == () { () } else {
        (
          contacts.map(c => (
            c
              + (
                alt: if c.alt == auto { _contact-alt(c.icon, labels) } else {
                  c.alt
                },
              )
          )),
        )
      },
      uppercase: uppercase,
      // Framed as `alta()` frames `basics.image`, at its default size
      // and shape; `alt` is the person's name.
      photo: if photo != none {
        _portrait(
          photo,
          prefs.image-size,
          _plain(name),
          shape: prefs.image-shape,
        )
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
///   their text), in order. The one matching the document's author
///   (`#set document(author: ..)`), ignoring case, is set apart.
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
    (
      v => type(v) == dictionary and v.values().all(id => type(id) == str),
      "a dictionary of strings",
    ),
  )
  context {
    // `alta()`'s readers, over the arguments in its CV shape; an
    // author given as content is matched and shown as its text.
    let refs = _identifier-refs(_identifiers((identifiers: identifiers)))
    // `document.author` is an array of strings: Typst wraps an author
    // set as a string, and leaves it empty when unset.
    let owners = _owner-keys(document.author)
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
/// pills, with an optional level: a term such as "Expert" shows as dots,
/// any other text as written.
///
/// - name (content, str): The group's name.
/// - keywords (array): Its keywords, each a pill.
/// - level (str, content, none): Its level, after the name: a rating
///   term (`"Beginner"`, `"Intermediate"`, `"Advanced"`, `"Expert"`, …)
///   as dots out of 5, anything else as written.
/// -> content
#let skills(name, keywords, level: none) = {
  let prefs = _default-preferences
  _keyword-rows((
    (
      name: name,
      keywords: keywords,
      mark: _rating-mark(
        _skill-rating((level: level), prefs),
        prefs.max-rating,
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
