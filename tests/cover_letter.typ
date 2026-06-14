// Cover-letter fixture. Covers the `auto` date path (routed through
// `_format_date` so it picks up `dateFormat` + `labels.months`), the
// `labels.closing` override, an explicit salutation, and a multi-line
// recipient block. Mirrors the cover-letter usage a real caller would
// reach for off the same `basics` dict that drives `alta()`.

#import "../lib.typ": cover-letter

#cover-letter(
  (
    basics: (
      name: "Oisín Mac Cárthaigh",
      label: "Innealtóir Bogearraí",
      email: "oisin@example.com",
      phone: "+353 1 555 0100",
      location: "Baile Átha Cliath",
    ),
  ),
  // `auto` substitutes today's date at compile time. tests/*.typ
  // outputs aren't byte-pinned in CI, so the floating value is fine.
  date: auto,
  recipient: [
    Forge Liffey \
    Cé Bhaile Átha Cliath \
    Baile Átha Cliath 2
  ],
  salutation: [A chara,],
  labels: (
    closing: "Le meas,",
  ),
  [
    Litir bheag thástála. Ní gá gur foirfe an leagan amach — is é an
    aidhm ná an cosán a chuir trí gach craobh den fheidhm
    `cover-letter` chun deimhniú go n-oibríonn an ceanntásc roinnte,
    an dáta `auto`, an seoladh, an beannú, agus an chríoch faoi
    `labels.closing`.
  ],
)
