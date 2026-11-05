// The colour themes and the deprecated accent palettes, re-exported
// from `lib.typ`. A theme is `_tokens` overrides (`theme.typ`), any
// subset of them; the built-in ones set every colour role.

#import "theme.typ": _hue-colours, _tokens

// Each built-in theme is tones of one hue, ranked: the `name` its
// deepest, the section titles its namesake, the details (`accent`:
// organisations, pills, dots, icons) a livelier tone, and the rule
// under each title a pale tint, so the title leads rather than its
// line. The text greys lean towards the hue (warm under crimson, cool
// under navy), each at least 4.5:1 on white; every text role survives
// a B&W photocopy.

/// The built-in themes for `preferences.theme`: one per hue, and
/// `altacv`, with dark red headings over a gold rule.
/// -> dictionary
#let themes = (
  teal: (colours: _tokens.colours),
  navy: (
    colours: _hue-colours((
      name: rgb("#13284A"),
      heading: rgb("#1A3A6C"),
      headingRule: rgb("#A3B5D1"),
      accent: rgb("#2C5491"),
      emphasis: rgb("#1C2330"),
      body: rgb("#535C6B"),
    )),
  ),
  crimson: (
    colours: _hue-colours((
      name: rgb("#6E1C1F"),
      heading: rgb("#9E2A2B"),
      headingRule: rgb("#DDB0A8"),
      accent: rgb("#9E2A2B"),
      emphasis: rgb("#2B2322"),
      body: rgb("#645A57"),
    )),
  ),
  forest: (
    colours: _hue-colours((
      name: rgb("#1E3F27"),
      heading: rgb("#2E5E3A"),
      headingRule: rgb("#AFC6AE"),
      accent: rgb("#3A7048"),
      emphasis: rgb("#222A23"),
      body: rgb("#56605A"),
    )),
  ),
  plum: (
    colours: _hue-colours((
      name: rgb("#421B4C"),
      heading: rgb("#5F2A6E"),
      headingRule: rgb("#CDB3D4"),
      accent: rgb("#75398A"),
      emphasis: rgb("#2A2230"),
      body: rgb("#5E5763"),
    )),
  ),
  // Greys only, for a print-first CV; a cool slate keeps the details
  // apart from the text.
  charcoal: (
    colours: _hue-colours((
      name: rgb("#1E2124"),
      heading: rgb("#3B3B3B"),
      headingRule: rgb("#B7BCC1"),
      accent: rgb("#4A525A"),
      emphasis: rgb("#23262A"),
      body: rgb("#595E63"),
    )),
  ),
  // Two hues: dark red over a gold rule, the name near-black and the
  // tagline in the red.
  altacv: (
    colours: _hue-colours((
      name: rgb("#1C1414"),
      heading: rgb("#4A0E0E"),
      headingRule: rgb("#D9BE73"),
      accent: rgb("#8F0D0D"),
      emphasis: rgb("#2B2222"),
      body: rgb("#5F5654"),
    ))
      + (tagline: rgb("#8F0D0D")),
  ),
)

/// The colour each single-hue theme is named for, its section titles'.
/// Deprecated: use `themes`.
/// -> dictionary
#let palettes = (
  themes
    .pairs()
    .filter(((k, _)) => k != "altacv")
    .map(((k, t)) => (k, t.colours.heading))
    .to-dict()
)
