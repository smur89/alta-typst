// altacv — a two-column CV template for Typst. Forked from George
// Honeywood's alta-typst (https://github.com/GeorgeHoneywood/alta-typst,
// MIT, © 2023 George Honeywood) and rewritten around a JSON
// Resume-style data dict. The README credits its inspirations.
//
// Public entry: `alta(cv, ...)` plus the helpers in the README.
// `sections/` has one renderer per CV part, mapping it onto
// `internal/components/`; the column sections are bound in
// `internal/registry.typ`. `internal/data/` reads and checks the CV,
// labels and preferences, `internal/design/` holds the theme, and
// `internal/util/` the generic helpers.
//
// Every colour, size and gap, and the sizing rule they follow, live
// in `internal/design/theme.typ`.

// The public API, and nothing else: Typst re-exports every name a
// module imports, so internal helpers stay behind `internal/render.typ`
// rather than being imported here (see the README's Helpers section).
#import "internal/render.typ": alta, alta-from-json, altacv
#import "internal/footers.typ": alta-footer, alta-updated-footer
#import "internal/data/defaults.typ": maps-providers
#import "internal/data/json-resume.typ": from-json-resume
#import "internal/design/presets.typ": palettes, themes
#import "internal/primitives.typ": divider, name, styled-link, tag, term
#import "internal/icons.typ": icon
#import "internal/components/ratings.typ": rating
#import "internal/blocks.typ": (
  contact, cv-columns, cv-header, entry, label-row, publication, skills,
)
// A module: `adapter.format-date(..)`, the readers for a mapping of
// your own.
#import "internal/adapter.typ" as adapter

/// A generic silhouette (SVG bytes) for `basics.image`, so a CV (the
/// `typst init` starter's, say) compiles before its own photo is
/// added.
/// -> bytes
#let avatar-placeholder = read("assets/avatar-placeholder.svg", encoding: none)
