// Header rendering — name + label + summary + contact bar, optionally
// with a circular portrait. Handles every supported layout shape
// (portrait left / right / centred above / centred below) plus all
// contact-bar quirks (tel: URI normalisation, location maps deep link,
// per-channel link suppression).

#import "state.typ": (
  _body_size_state, _accent_state, _body_colour, _emphasis_colour, maps-providers,
)
#import "text.typ": _format_location, _url_encode
#import "icons.typ": icon, _profile_networks, _network_aliases

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
