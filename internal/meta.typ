// PDF metadata helpers. The actual `set document(...)` call lives in
// the top-level `alta()` template entrypoint; this module captures the
// pure derivations that feed it.

// Flatten every skill group's `keywords` into a de-duplicated array
// for the PDF `Keywords` field. Insertion order is preserved so the
// metadata reflects the author's curated ordering.
#let _collect_keywords(skills) = {
  let seen = ()
  for group in skills {
    for kw in group.at("keywords", default: ()) {
      if type(kw) == str and kw != "" and kw not in seen { seen.push(kw) }
    }
  }
  seen
}
