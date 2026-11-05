// The building blocks for a CV written in markup inside the `altacv`
// template (#370): what Typst has no element for, over the components
// `alta()` draws with. Re-exported from `lib.typ`.

#import "data/options.typ": _merge-options
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
/// same section or group.
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
  // Under no section, level 1: a heading level never skips.
  let level = if parent == none { 1 } else { parent.level + 1 }
  let earlier = selector(<alta-internal-entry>).before(here())
  let siblings = if parent == none { earlier } else {
    earlier.after(parent.location())
  }
  // `alta()` joins a section's entries with the divider, so none
  // precedes the first of a section or group.
  if query(siblings).len() > 0 { divider() }
  block(breakable: false, _entry(
    // The icons' alt text, in the document's language, as `alta()`'s.
    _merge-options((:), (:), lang: text.lang).labels,
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
    level: level,
  ))
}
