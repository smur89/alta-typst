# Security policy

## Reporting a vulnerability

If you've found a security issue in `altacv` — for example, a way for a malicious `cv` dict to escape into shell execution, exfiltrate environment data via the rendered PDF, or otherwise compromise the host running `typst compile` — please **do not** open a public issue.

Instead, open a private report via [GitHub Security Advisories](https://github.com/smur89/alta-typst/security/advisories/new). I'll acknowledge within a few days and work with you on a fix.

## Scope

`altacv` is a Typst template — it renders user-supplied data to PDF/HTML. The most realistic attack surface is malicious input crafted to exploit a `typst` runtime bug; please report those upstream at [typst/typst](https://github.com/typst/typst/security). Issues *specific* to this template (e.g. an icon lookup that reads outside the bundled `fonts/` / `assets/` directories, or a label string that is interpreted unsafely) are in scope here.

## Supported versions

Only the most recent published release on [Typst Universe](https://typst.app/universe/package/altacv) receives fixes.
