// Cover-letter fixture covering the auto date path, the labels.closing
// override, and a minimal recipient block. Pairs with the more
// complete demo in examples/cover_letter.typ.

#import "../lib.typ": cover-letter

#cover-letter(
  (
    basics: (
      name: "Oisín Mac Cárthaigh",
      label: "Innealtóir Bogearraí",
      email: "oisin@example.com",
      location: "Baile Átha Cliath",
    ),
  ),
  // `auto` date is substituted at compile time. Pinning a fixed date
  // would defeat that branch; tests/*.typ outputs are not byte-pinned
  // in CI, so the floating "today" value is fine here.
  date: auto,
  recipient: [Forge Liffey \ Cé Bhaile Átha Cliath],
  salutation: [A chara,],
  [
    Litir bheag thástála. Ní gá gur foirfe an leagan amach — is é an
    aidhm ná an cosán a chuir trí gach cuid den fheidhm
    `cover-letter` chun deimhniú go ndéantar gach craobh a iniúchadh.
  ],
  labels: (
    closing: "Le meas,",
  ),
)
