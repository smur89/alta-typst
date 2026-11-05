// The building blocks for a CV written in markup inside the `altacv`
// template (#370): what Typst has no element for, over the components
// `alta()` draws with. Re-exported from `lib.typ`.

#import "data/defaults.typ": _default-labels, _translations
#import "primitives.typ": divider
#import "components/entry.typ": _entry

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
  // precedes the first of a section or group.
  if query(siblings).len() > 0 { divider() }
  [#metadata(none)<alta-internal-entry-mark>]
  block(breakable: false, _entry(
    // The icons' alt text, in the document's language, as `alta()`'s
    // labels resolve it: its bundled translation over the English.
    _default-labels + _translations.at(text.lang, default: (:)),
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
