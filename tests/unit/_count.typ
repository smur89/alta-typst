// Counts the renders of a string: `count(s)` returns its count, a
// state to read with `.final()`, and the rule to install as
// `show s: rule`, which counts each match and draws it unchanged.
#let count(s) = {
  let seen = state("seen-" + s, 0)
  (
    seen,
    it => {
      seen.update(n => n + 1)
      it
    },
  )
}
