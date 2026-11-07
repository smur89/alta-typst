# Changelog

## [1.9.0](https://github.com/smur89/alta-typst/compare/v1.8.0...v1.9.0) (2026-11-07)


### Features

* `adapter.preferences()`, `adapter.entries()`, `adapter.group-by-type()` and `adapter.custom()` let your own mapping read the CV as `alta()` does ([3bdcdcf](https://github.com/smur89/alta-typst/commit/3bdcdcf82349722ada48c2ffed72af8353cddf5a))
* `alta-footer()` and `alta-updated-footer()` page footers for the template ([#393](https://github.com/smur89/alta-typst/issues/393)) ([6c15427](https://github.com/smur89/alta-typst/commit/6c15427ba4557728562b28388467c83403d6a46a))
* `altacv.with(labels: ..)` sets the labels for everything the template draws, including CVs written in markup ([9ccd3c9](https://github.com/smur89/alta-typst/commit/9ccd3c9c19ec80871a8fdb23e26dae74c288ffd3))
* `from-json-resume` and `alta-from-json` accept JSON Resume 1.7.0 fields, and `custom.altacv` extensions in a `resume.json` (gairm-import 0.10.1) ([a30f145](https://github.com/smur89/alta-typst/commit/a30f1457848344620a6127c995387f0a396ca95e))
* `tag(category:)`; `label:` is deprecated ([bdbb122](https://github.com/smur89/alta-typst/commit/bdbb122bc265c07463787e8bd0b5eaa531cf9b9e))
* a `cv-columns` block for the two-column layout with the theme's gap ([a4a9b0c](https://github.com/smur89/alta-typst/commit/a4a9b0cd6252124b7164fb0a04bcef8702fd8fdb))
* accept `pageFooter: auto` and give enums and checks one home ([#288](https://github.com/smur89/alta-typst/issues/288)) ([6b55aec](https://github.com/smur89/alta-typst/commit/6b55aec80b56daf1af1450677cf2af22779d7ea7))
* add field 'keywords' for work/volunteer (like projects) ([#215](https://github.com/smur89/alta-typst/issues/215)) ([af49519](https://github.com/smur89/alta-typst/commit/af49519a7ec19e6300a580b010aa16342ea418af))
* add opt-in justified text with hyphenation ([#318](https://github.com/smur89/alta-typst/issues/318)) ([7591d3c](https://github.com/smur89/alta-typst/commit/7591d3c9f0d73445f8cfdaabec0678121b56264e))
* add ORCID as a profile network ([#313](https://github.com/smur89/alta-typst/issues/313)) ([1bb93c1](https://github.com/smur89/alta-typst/commit/1bb93c1e1d114d327f386f33712b0a6e76c47408))
* add rust, bauhaus, riso, phosphor and catppuccin themes ([d17d8de](https://github.com/smur89/alta-typst/commit/d17d8de768a1579893c9fdbbaf582b6923c00d46))
* add square and rounded portrait shapes ([#315](https://github.com/smur89/alta-typst/issues/315)) ([f3ac7f7](https://github.com/smur89/alta-typst/commit/f3ac7f793143343ad9a6a749700f4d531d9393e1))
* an `adapter` module for writing your own mapping: `format-date`, `location-text`, `basics-contacts`, `fluency-rating`, `group-by-type`, `labels` ([a4a9b0c](https://github.com/smur89/alta-typst/commit/a4a9b0cd6252124b7164fb0a04bcef8702fd8fdb))
* an altacv template, `#show: altacv.with(theme: ..)`, after which your own set and show rules win, with `alta(cv)` inside it rendering the CV's content ([#393](https://github.com/smur89/alta-typst/issues/393)) ([6c15427](https://github.com/smur89/alta-typst/commit/6c15427ba4557728562b28388467c83403d6a46a))
* block arguments for everything `alta()` shows: `cv-header(name:, photo-size:, photo-shape:)` (aligned by the surrounding `align`), `entry(summary:, subtitle:, keywords-lead:, date: (start, end))`, `publication(owners:, citation:)`, `skills(level: <number>, max:)`, and `rating` with a text value ([a4a9b0c](https://github.com/smur89/alta-typst/commit/a4a9b0cd6252124b7164fb0a04bcef8702fd8fdb))
* bold the CV owner under other spellings of their name ([#317](https://github.com/smur89/alta-typst/issues/317)) ([83d789e](https://github.com/smur89/alta-typst/commit/83d789e5bd905ca243555465f76a4398cea72664))
* build each theme from token overrides covering the whole look, separators and treatments included, so later themes can set more than colours ([#352](https://github.com/smur89/alta-typst/issues/352)) ([babfba8](https://github.com/smur89/alta-typst/commit/babfba8e6b678c5f9710929c5c8ce788b27195cd))
* building blocks for a CV written in markup inside the template: `cv-header`, `contact`, `entry`, `publication`, `skills` and `label-row` ([#395](https://github.com/smur89/alta-typst/issues/395)) ([64b9648](https://github.com/smur89/alta-typst/commit/64b9648f9fa4955af939ca2d23c332fcd1cb7914))
* choose labels from the document's language ([#384](https://github.com/smur89/alta-typst/issues/384)) ([e24b9f5](https://github.com/smur89/alta-typst/commit/e24b9f5c1cec654be783a76ee1304b82d2f5a10e))
* colour each built-in theme's tagline and lift its name slightly so the theme reaches the header ([d17d8de](https://github.com/smur89/alta-typst/commit/d17d8de768a1579893c9fdbbaf582b6923c00d46))
* colour themes and per-role colour overrides ([#350](https://github.com/smur89/alta-typst/issues/350)) ([dc6ed7f](https://github.com/smur89/alta-typst/commit/dc6ed7f764158078a9b168306b13757fd57dcfeb)), closes [#299](https://github.com/smur89/alta-typst/issues/299)
* deprecate `name()`, `term()` and `styled-link()` in favour of `entry(..)` ([bdbb122](https://github.com/smur89/alta-typst/commit/bdbb122bc265c07463787e8bd0b5eaa531cf9b9e))
* deprecate the `<alta-divider>` part label ([#383](https://github.com/smur89/alta-typst/issues/383)) ([5471f8c](https://github.com/smur89/alta-typst/commit/5471f8c8ed2b130e5dcf5944e2290ebb0b0ab8b9))
* draw entry separators with Typst's divider element ([#382](https://github.com/smur89/alta-typst/issues/382)) ([b77539f](https://github.com/smur89/alta-typst/commit/b77539fffb922446a7241b4ec8b429e9adabdd18))
* drop the dividers between languages and between certificates ([#292](https://github.com/smur89/alta-typst/issues/292)) ([d02b661](https://github.com/smur89/alta-typst/commit/d02b6610d8e12c823c5b4714d2f0e83269b2ebe9))
* fit the starter CV on one page ([#292](https://github.com/smur89/alta-typst/issues/292)) ([d02b661](https://github.com/smur89/alta-typst/commit/d02b6610d8e12c823c5b4714d2f0e83269b2ebe9))
* give an education score its own line ([#292](https://github.com/smur89/alta-typst/issues/292)) ([d02b661](https://github.com/smur89/alta-typst/commit/d02b6610d8e12c823c5b4714d2f0e83269b2ebe9))
* give each built-in theme ranked tones of one hue ([#359](https://github.com/smur89/alta-typst/issues/359)) ([2af49db](https://github.com/smur89/alta-typst/commit/2af49db7fb3151f3d40896cf3bd00337681d9b74))
* give the date and location icons alt text ([#316](https://github.com/smur89/alta-typst/issues/316)) ([adca74f](https://github.com/smur89/alta-typst/commit/adca74f9cbf3e766477cddd26251fed24bc62b4d))
* halve the section rule's weight ([#293](https://github.com/smur89/alta-typst/issues/293)) ([9088ed6](https://github.com/smur89/alta-typst/commit/9088ed666f19b85f8ab139659d94b7352ddbf112))
* inside the template the name is Typst's `title` element and sections are level-1 headings, styled by show-set rules a user's own rules override exactly ([#395](https://github.com/smur89/alta-typst/issues/395)) ([64b9648](https://github.com/smur89/alta-typst/commit/64b9648f9fa4955af939ca2d23c332fcd1cb7914))
* inside the template, `alta(cv)` renders through `adapter/json-resume.typ`, a JSON Resume mapping in the public API you can copy and edit ([#370](https://github.com/smur89/alta-typst/issues/370)) ([a4a9b0c](https://github.com/smur89/alta-typst/commit/a4a9b0cd6252124b7164fb0a04bcef8702fd8fdb))
* kebab-case for every option the package defines ([#389](https://github.com/smur89/alta-typst/issues/389)) ([e734a31](https://github.com/smur89/alta-typst/commit/e734a31ffc7c65e7ab5f88d8a4148ac17e85c7b2))
* keep internal labels out of the public label namespace ([#338](https://github.com/smur89/alta-typst/issues/338)) ([8454f21](https://github.com/smur89/alta-typst/commit/8454f210e16401ad1d8ebe7caa24eeb41bc0a581)), closes [#333](https://github.com/smur89/alta-typst/issues/333)
* keep pills for skills alone ([#293](https://github.com/smur89/alta-typst/issues/293)) ([9088ed6](https://github.com/smur89/alta-typst/commit/9088ed666f19b85f8ab139659d94b7352ddbf112))
* label an entry's keyword line as a paragraph part ([#358](https://github.com/smur89/alta-typst/issues/358)) ([c36d455](https://github.com/smur89/alta-typst/commit/c36d455597641d5cbf682b25680d75de1f7fba96))
* label the contact entries, dates and locations for show rules ([#328](https://github.com/smur89/alta-typst/issues/328)) ([08c73a8](https://github.com/smur89/alta-typst/commit/08c73a800c5adefb25dfab01ff850533704ea385))
* label the name, headline and headings for show rules ([#329](https://github.com/smur89/alta-typst/issues/329)) ([d0ffad4](https://github.com/smur89/alta-typst/commit/d0ffad426b08124055bcf9de6b4441455bbbc81c))
* label the rating dots and the date and location icons for show rules ([#347](https://github.com/smur89/alta-typst/issues/347)) ([faa6c0d](https://github.com/smur89/alta-typst/commit/faa6c0dbda8904ac998cc840826ce119c1fe6269)), closes [#301](https://github.com/smur89/alta-typst/issues/301)
* label the remaining parts for show rules ([#330](https://github.com/smur89/alta-typst/issues/330)) ([84fc9ba](https://github.com/smur89/alta-typst/commit/84fc9ba7caba179064e0d697c47855b6d3f93668))
* label the section rule and the dividers for show rules ([#343](https://github.com/smur89/alta-typst/issues/343)) ([d579b23](https://github.com/smur89/alta-typst/commit/d579b239e4e5afaa8460e01dce0dd60e6be1239d))
* layer the look's overrides: a theme, then `preferences.colours`, then show rules on the labelled parts, each winning over the one before ([#352](https://github.com/smur89/alta-typst/issues/352)) ([babfba8](https://github.com/smur89/alta-typst/commit/babfba8e6b678c5f9710929c5c8ce788b27195cd))
* lead each entry with its role ([#292](https://github.com/smur89/alta-typst/issues/292)) ([d02b661](https://github.com/smur89/alta-typst/commit/d02b6610d8e12c823c5b4714d2f0e83269b2ebe9))
* let a show rule draw an entry's keywords as pills ([#356](https://github.com/smur89/alta-typst/issues/356)) ([1a894b3](https://github.com/smur89/alta-typst/commit/1a894b3d2ebe4fa313f5e73db584efffd45851c1)), closes [#215](https://github.com/smur89/alta-typst/issues/215)
* let a theme set any token, the font included ([#354](https://github.com/smur89/alta-typst/issues/354)) ([20e05ec](https://github.com/smur89/alta-typst/commit/20e05ecc94df2936328a247a3e5c2e1c0b573b22)), closes [#299](https://github.com/smur89/alta-typst/issues/299)
* let show rules set the name and heading fonts ([#300](https://github.com/smur89/alta-typst/issues/300)) ([afd7d57](https://github.com/smur89/alta-typst/commit/afd7d5758b2b777df836f4a6fa65e858b9407242))
* load a `resume.json` with gairm-import's `parse`, as `alta(parse(path("resume.json")))`; `alta-from-json` and `from-json-resume` are deprecated ([9f567f4](https://github.com/smur89/alta-typst/commit/9f567f415bfe879f34c08b23113a53ae1407c7f3))
* map extra profile networks to icons ([#344](https://github.com/smur89/alta-typst/issues/344)) ([635899e](https://github.com/smur89/alta-typst/commit/635899e43f390cf777fa58e83c9c44f5a3b1bfc0)), closes [#303](https://github.com/smur89/alta-typst/issues/303)
* map project types to icons with `preferences.projectIcons` ([#292](https://github.com/smur89/alta-typst/issues/292)) ([d02b661](https://github.com/smur89/alta-typst/commit/d02b6610d8e12c823c5b4714d2f0e83269b2ebe9))
* move publication icons to preferences.publicationIcons ([#267](https://github.com/smur89/alta-typst/issues/267)) ([0a44f64](https://github.com/smur89/alta-typst/commit/0a44f64c66ef641cedb55102d5a7b3ff6b64f576))
* print full URLs for unlinked contacts ([#348](https://github.com/smur89/alta-typst/issues/348)) ([439abd3](https://github.com/smur89/alta-typst/commit/439abd32ad435f3f84a88e3b8769bb0c0b4e6ab2)), closes [#308](https://github.com/smur89/alta-typst/issues/308)
* put a publication's source and date on one line ([#292](https://github.com/smur89/alta-typst/issues/292)) ([d02b661](https://github.com/smur89/alta-typst/commit/d02b6610d8e12c823c5b4714d2f0e83269b2ebe9))
* put contact details and profiles on separate lines ([#292](https://github.com/smur89/alta-typst/issues/292)) ([d02b661](https://github.com/smur89/alta-typst/commit/d02b6610d8e12c823c5b4714d2f0e83269b2ebe9))
* quieten the section headings ([#292](https://github.com/smur89/alta-typst/issues/292)) ([d02b661](https://github.com/smur89/alta-typst/commit/d02b6610d8e12c823c5b4714d2f0e83269b2ebe9))
* read JSON Resume data in kebab-case internally ([#391](https://github.com/smur89/alta-typst/issues/391)) ([25b5a57](https://github.com/smur89/alta-typst/commit/25b5a578fb0828de85910ee4105bfcec340da9dc))
* read the text size in context instead of render-time state ([#387](https://github.com/smur89/alta-typst/issues/387)) ([53a76dc](https://github.com/smur89/alta-typst/commit/53a76dc30a1165b8454aa1e1917b30fff152f819))
* rebuild the theme on named design tokens ([#291](https://github.com/smur89/alta-typst/issues/291)) ([7ccf077](https://github.com/smur89/alta-typst/commit/7ccf07716e1432d870fcddcf343225665858fa2b))
* render education[].area alongside studyType ([#321](https://github.com/smur89/alta-typst/issues/321)) ([ab5352a](https://github.com/smur89/alta-typst/commit/ab5352a9012981944f6ad2a090a632734a99ff16))
* render skills[].level ([#324](https://github.com/smur89/alta-typst/issues/324)) ([1926455](https://github.com/smur89/alta-typst/commit/19264553c34b100f244d29fc56da05ece12a43f6))
* section, entry and group titles take their colour, weight and tracking from show-set rules, so a later rule overrides them ([#393](https://github.com/smur89/alta-typst/issues/393)) ([6c15427](https://github.com/smur89/alta-typst/commit/6c15427ba4557728562b28388467c83403d6a46a))
* separate a skill group's label from its keywords with an en dash ([#292](https://github.com/smur89/alta-typst/issues/292)) ([d02b661](https://github.com/smur89/alta-typst/commit/d02b6610d8e12c823c5b4714d2f0e83269b2ebe9))
* set each entry's date and location at its right edge, with their icons ([#293](https://github.com/smur89/alta-typst/issues/293)) ([9088ed6](https://github.com/smur89/alta-typst/commit/9088ed666f19b85f8ab139659d94b7352ddbf112))
* set group headings apart from the entries under them ([#292](https://github.com/smur89/alta-typst/issues/292)) ([d02b661](https://github.com/smur89/alta-typst/commit/d02b6610d8e12c823c5b4714d2f0e83269b2ebe9))
* set the contact bar a step below body text ([#291](https://github.com/smur89/alta-typst/issues/291)) ([7ccf077](https://github.com/smur89/alta-typst/commit/7ccf07716e1432d870fcddcf343225665858fa2b))
* set the objective in the header, under the tagline, as the new &lt;alta-objective&gt; part ([85465ee](https://github.com/smur89/alta-typst/commit/85465ee53216577a03ec1157e04f87c44b085c0b))
* show contact-bar URLs without their scheme ([#291](https://github.com/smur89/alta-typst/issues/291)) ([7ccf077](https://github.com/smur89/alta-typst/commit/7ccf07716e1432d870fcddcf343225665858fa2b))
* standalone `alta(cv, preferences:)` is deprecated in favour of the `altacv` template ([9f567f4](https://github.com/smur89/alta-typst/commit/9f567f415bfe879f34c08b23113a53ae1407c7f3))
* stop rendering basics.pronouns ([#312](https://github.com/smur89/alta-typst/issues/312)) ([36a2b71](https://github.com/smur89/alta-typst/commit/36a2b71512f8c57e8450f9833c4322f29637c2ac))
* take Typst's own values where options took names in strings ([#386](https://github.com/smur89/alta-typst/issues/386)) ([764ec96](https://github.com/smur89/alta-typst/commit/764ec96954787741159f0498f210e95d32c2581a))
* the `typst init` starter ships its CV as `resume.json` too, with the switch to `alta-from-json` at the end of `cv.typ` ([#370](https://github.com/smur89/alta-typst/issues/370)) ([07551e9](https://github.com/smur89/alta-typst/commit/07551e92a86964d6ced632ec53c6f2e5f6d3bb74))
* the mapping `resume()` takes validated JSON Resume, such as gairm-import's `parse(..)` output, with one function per section ([3bdcdcf](https://github.com/smur89/alta-typst/commit/3bdcdcf82349722ada48c2ffed72af8353cddf5a))


### Bug Fixes

* a `#show: altacv` nested inside another keeps the heading sizes instead of multiplying them ([0de2fea](https://github.com/smur89/alta-typst/commit/0de2fea6d511e771c2e3aba0c40fcee66e40805d))
* a column list given as a string gets a guided error ([f13ed93](https://github.com/smur89/alta-typst/commit/f13ed9352af6ff69a031e880397418b7aa3b9d0c))
* a language with no fluency or rating renders its name alone, instead of failing ([06a2b58](https://github.com/smur89/alta-typst/commit/06a2b583963e23aba829f54ff508b90dff73891b))
* a location's shown values are checked, with guided errors where they used to crash ([f13ed93](https://github.com/smur89/alta-typst/commit/f13ed9352af6ff69a031e880397418b7aa3b9d0c))
* a skill or interest group without a name renders without a category, instead of failing ([3bdcdcf](https://github.com/smur89/alta-typst/commit/3bdcdcf82349722ada48c2ffed72af8353cddf5a))
* a standalone `accent` draws the tagline in the emphasis grey, as 1.8.0 did ([0de2fea](https://github.com/smur89/alta-typst/commit/0de2fea6d511e771c2e3aba0c40fcee66e40805d))
* a template's footers keep its labels and theme on every page of its scope, including a blank page after a trailing pagebreak ([9080f0d](https://github.com/smur89/alta-typst/commit/9080f0df0a194a4a2bb9c8012229e597a3eea25e))
* an outer `set par(justify: true)` justifies a standalone CV's prose again ([bdbb122](https://github.com/smur89/alta-typst/commit/bdbb122bc265c07463787e8bd0b5eaa531cf9b9e))
* centre inline icons and rating dots on the text ([#320](https://github.com/smur89/alta-typst/issues/320)) ([0db7c41](https://github.com/smur89/alta-typst/commit/0db7c41ea2e32e583e3588213389105e3ebae949))
* colour a glyph that replaces a rating dot with the dot's own colour ([9469e1d](https://github.com/smur89/alta-typst/commit/9469e1d721619add7cef274455aeb082a000b80f))
* follow-ups to the altacv template review ([#394](https://github.com/smur89/alta-typst/issues/394)) ([df0bcc7](https://github.com/smur89/alta-typst/commit/df0bcc7fe79ea1f0ae214c0a9f2ec464f32c0111)), closes [#393](https://github.com/smur89/alta-typst/issues/393)
* **icons:** drop legacy baseline shifts that sink FA 7 glyphs ([#211](https://github.com/smur89/alta-typst/issues/211)) ([e90dd01](https://github.com/smur89/alta-typst/commit/e90dd01b5a45f33c6fd4aa730e8644091f67f937))
* inside the template, `alta(cv, labels:)` reaches every entry's "Present" and date and location alt text ([9ccd3c9](https://github.com/smur89/alta-typst/commit/9ccd3c9c19ec80871a8fdb23e26dae74c288ffd3))
* make validation errors uniform ("X must be Y, got: Z") ([#282](https://github.com/smur89/alta-typst/issues/282)) ([3d89599](https://github.com/smur89/alta-typst/commit/3d895999e295b94d2102aecda0b0eb85cc91a444))
* nest the headings under the name and check PDF/UA ([#341](https://github.com/smur89/alta-typst/issues/341)) ([bda2299](https://github.com/smur89/alta-typst/commit/bda2299bc7ab358614168e7dd155f34eff59730f))
* raise every CV error, including unknown `dateFormat` tokens, before rendering ([#283](https://github.com/smur89/alta-typst/issues/283)) ([7738579](https://github.com/smur89/alta-typst/commit/7738579caf7be5ca904c1f608948ea4f1c682bee))
* regenerate the justify fixture render ([#319](https://github.com/smur89/alta-typst/issues/319)) ([ecbcd67](https://github.com/smur89/alta-typst/commit/ecbcd67fc6c16bbb523078f9a840ad24313a19b7))
* report wrong-typed CV fields with guided errors before rendering ([#287](https://github.com/smur89/alta-typst/issues/287)) ([ecc2a7c](https://github.com/smur89/alta-typst/commit/ecc2a7cbadc27be5f974bab0fd5d6d559b7f4d32))
* stop leaking internal helpers through `#import "@preview/altacv:…": *` ([#286](https://github.com/smur89/alta-typst/issues/286)) ([bff8560](https://github.com/smur89/alta-typst/commit/bff8560ef260b1c69af6037327af34eed21ea0c4))
* the template's footers leave no metadata for `query` to find ([037e7be](https://github.com/smur89/alta-typst/commit/037e7be61299acc65151b13205345bcd1711566d))
* treat `none` (JSON null) CV fields as absent instead of crashing ([#287](https://github.com/smur89/alta-typst/issues/287)) ([ecc2a7c](https://github.com/smur89/alta-typst/commit/ecc2a7cbadc27be5f974bab0fd5d6d559b7f4d32))

## [1.8.0](https://github.com/smur89/alta-typst/compare/v1.7.0...v1.8.0) (2026-11-02)


### Features

* honour references[].availableOnRequest and head publication type codes from labels ([#240](https://github.com/smur89/alta-typst/issues/240)) ([bd1ed73](https://github.com/smur89/alta-typst/commit/bd1ed73ce94c35e9724b10c7529b2fb05f2065c9))
* lay every entry out through one shared component ([#262](https://github.com/smur89/alta-typst/issues/262)) ([9a3076f](https://github.com/smur89/alta-typst/commit/9a3076f1d4741a5d2f41703d437ac5ee860983c6))
* read altacv's non-spec fields from custom.altacv ([#247](https://github.com/smur89/alta-typst/issues/247)) ([04a34ab](https://github.com/smur89/alta-typst/commit/04a34ab25c834e6b9de29884694e1692eaf78cf4))
* render basics.pronouns and deprecate the description aliases ([#241](https://github.com/smur89/alta-typst/issues/241)) ([f10f818](https://github.com/smur89/alta-typst/commit/f10f81849c745c307fb56bf12a612856b5435d5e))
* render certificates as entries with summary, credentialId and expiryDate ([#244](https://github.com/smur89/alta-typst/issues/244)) ([874cce9](https://github.com/smur89/alta-typst/commit/874cce9cb52510f84a1eabbebf5f6482424f322d))
* render education summary and location, and projects[].summary ([#238](https://github.com/smur89/alta-typst/issues/238)) ([bdbe061](https://github.com/smur89/alta-typst/commit/bdbe061f8e7e3f684fd53954408cbb96b0859772))
* render publications volume, issue and pages ([#250](https://github.com/smur89/alta-typst/issues/250)) ([e5525fc](https://github.com/smur89/alta-typst/commit/e5525fc8f40bed99c1dcd2e82d1f0da91d10f455))
* render publications[].authors ([#251](https://github.com/smur89/alta-typst/issues/251)) ([d3a9b53](https://github.com/smur89/alta-typst/commit/d3a9b536eb07037624d327805db03ec422b0f2ab))
* render publications[].identifiers ([#249](https://github.com/smur89/alta-typst/issues/249)) ([d4d684e](https://github.com/smur89/alta-typst/commit/d4d684ec5dfa1bfce33962c3094ad423c57a25b9))
* render references[].relationship, organization and date ([#258](https://github.com/smur89/alta-typst/issues/258)) ([b3022e5](https://github.com/smur89/alta-typst/commit/b3022e54e819a66ccb651bb87eae0c68c0ed08ba))
* render the top-level objective ([#259](https://github.com/smur89/alta-typst/issues/259)) ([824e0d5](https://github.com/smur89/alta-typst/commit/824e0d5d131bd5a5d2a16e298a883285edeeedc7))
* set the objective off with an accent rule ([#260](https://github.com/smur89/alta-typst/issues/260)) ([d2ae538](https://github.com/smur89/alta-typst/commit/d2ae538a750392d32d924f3a5decedae4b5f3947))


### Bug Fixes

* accept JSON Resume's structured location on work and volunteer ([#237](https://github.com/smur89/alta-typst/issues/237)) ([db388f7](https://github.com/smur89/alta-typst/commit/db388f796a0ba72a07bf2734197ec7a7699b63b0))
* **ci:** run build workflow steps with pipefail ([#257](https://github.com/smur89/alta-typst/issues/257)) ([440e9e7](https://github.com/smur89/alta-typst/commit/440e9e73f4c1d56ee5ab8d366c17ec62465e35bc))
* **deps:** update dependency gairm-import to v0.9.0 ([#213](https://github.com/smur89/alta-typst/issues/213)) ([62ef5d3](https://github.com/smur89/alta-typst/commit/62ef5d321ad506030c8c9490683206a777672a5a))
* reject unknown top-level CV keys in alta() ([#261](https://github.com/smur89/alta-typst/issues/261)) ([58a5db4](https://github.com/smur89/alta-typst/commit/58a5db440b895a99041a6456681b7e967dbfef79))
* scale fluency values to preferences.maxRating ([#248](https://github.com/smur89/alta-typst/issues/248)) ([1d9e362](https://github.com/smur89/alta-typst/commit/1d9e3628a4d7ed11e4d15d7b02a14589b1858072))
* small rendering consistencies ([#254](https://github.com/smur89/alta-typst/issues/254)) ([3bb767e](https://github.com/smur89/alta-typst/commit/3bb767ee1c90f44adf5788f8df0ea428f2fda2f3))
* validate every preference and section shape up front ([#252](https://github.com/smur89/alta-typst/issues/252)) ([a741f32](https://github.com/smur89/alta-typst/commit/a741f32c8e6f92c3114d6d3595001b14e59603f7))

## [1.7.0](https://github.com/smur89/alta-typst/compare/v1.6.0...v1.7.0) (2026-10-27)


### Features

* add alt text to header portrait and QR, mark icons decorative ([#190](https://github.com/smur89/alta-typst/issues/190)) ([88750b3](https://github.com/smur89/alta-typst/commit/88750b3192381a19c785f75c1726befbee203e82))
* localise the auto page footer and PDF title ([#188](https://github.com/smur89/alta-typst/issues/188)) ([d94835c](https://github.com/smur89/alta-typst/commit/d94835cf5d74533597761fe3c2bbbb7c64b3dfa1))
* name the network of each header profile for screen readers ([#209](https://github.com/smur89/alta-typst/issues/209)) ([c0657bb](https://github.com/smur89/alta-typst/commit/c0657bb6cf73278dc7ec9a8afb4fcc96862578cf))
* set the document language from labels.lang ([#207](https://github.com/smur89/alta-typst/issues/207)) ([04af217](https://github.com/smur89/alta-typst/commit/04af21743f6369f832c1fc74dd8aa2878d4ed08f))


### Bug Fixes

* **build:** rebuild renders on library changes and force drift-gate rebuilds ([#178](https://github.com/smur89/alta-typst/issues/178)) ([45eaaca](https://github.com/smur89/alta-typst/commit/45eaacaad3a41982df7c9cf0c31c7730d3a1fead))
* **deps:** build, test and render fixtures with Typst 0.15.1 ([#202](https://github.com/smur89/alta-typst/issues/202)) ([7852ac1](https://github.com/smur89/alta-typst/commit/7852ac18d3a72f3449675a06aff9b1c4d9a3d996))
* skip empty basics contact fields ([#181](https://github.com/smur89/alta-typst/issues/181)) ([d4743ed](https://github.com/smur89/alta-typst/commit/d4743edff824495d2c4d1b09ad98ebfccc1447b9))
* split the column gutter between both columns in two-column layouts ([#184](https://github.com/smur89/alta-typst/issues/184)) ([19c6544](https://github.com/smur89/alta-typst/commit/19c6544b9bc3ee4e84e17d30bdaf1256451bf9a4))
* use a real em dash in the default PDF title ([#207](https://github.com/smur89/alta-typst/issues/207)) ([04af217](https://github.com/smur89/alta-typst/commit/04af21743f6369f832c1fc74dd8aa2878d4ed08f))

## [1.6.0](https://github.com/smur89/alta-typst/compare/v1.5.0...v1.6.0) (2026-07-12)


### Features

* render JSON Resume meta.canonical and meta.version ([#163](https://github.com/smur89/alta-typst/issues/163)) ([daa4487](https://github.com/smur89/alta-typst/commit/daa4487e641a23a3c89ff8b8d50690b0a0d18447))
* render project entity, type, and roles ([#166](https://github.com/smur89/alta-typst/issues/166)) ([20e65bc](https://github.com/smur89/alta-typst/commit/20e65bc4192930630e59cdc83a23d4b9c7bbf9bb))
* render volunteer summary and url ([#165](https://github.com/smur89/alta-typst/issues/165)) ([e10c3b5](https://github.com/smur89/alta-typst/commit/e10c3b5f714f326d1f62423b1e8d1d5221c402e9))

## [1.5.0](https://github.com/smur89/alta-typst/compare/v1.4.3...v1.5.0) (2026-06-18)


### Features

* load resumes from JSON Resume via @preview/gairm-import ([#154](https://github.com/smur89/alta-typst/issues/154)) ([5cf278e](https://github.com/smur89/alta-typst/commit/5cf278ecac58d2856ae7b3449d98a7ea56c8ae66))


### Bug Fixes

* **docs:** restructure README for clarity and scannability ([#157](https://github.com/smur89/alta-typst/issues/157)) ([f0309d1](https://github.com/smur89/alta-typst/commit/f0309d10d9cf48e8d007d36d82b8d23eda0ddee9))

## [1.4.3](https://github.com/smur89/alta-typst/compare/v1.4.2...v1.4.3) (2026-06-17)


### Bug Fixes

* **pkg:** stop shipping example .typ sources to resolve relative-import warnings ([#151](https://github.com/smur89/alta-typst/issues/151)) ([96fe41e](https://github.com/smur89/alta-typst/commit/96fe41ebc4c29592a14e60dbee4010477dffac11))

## [1.4.2](https://github.com/smur89/alta-typst/compare/v1.4.1...v1.4.2) (2026-06-16)


### Bug Fixes

* ship CONTRIBUTING.md so the README's local link resolves ([#148](https://github.com/smur89/alta-typst/issues/148)) ([60eccce](https://github.com/smur89/alta-typst/commit/60eccce336baadbb2d7297bb57eff8da6dc597fd))

## [1.4.1](https://github.com/smur89/alta-typst/compare/v1.4.0...v1.4.1) (2026-06-16)


### Bug Fixes

* address typst-package-check warnings on 1.4.0 ([#146](https://github.com/smur89/alta-typst/issues/146)) ([9bb07ca](https://github.com/smur89/alta-typst/commit/9bb07ca5ec078501c8159856f5d749eb5bdbceb7))

## [1.4.0](https://github.com/smur89/alta-typst/compare/v1.3.1...v1.4.0) (2026-06-16)


### Features

* accept path() for basics.image ([#144](https://github.com/smur89/alta-typst/issues/144)) ([0f2fe07](https://github.com/smur89/alta-typst/commit/0f2fe075e4a74a1ae961a5b9a0b9e0049b7a7abd))

## [1.3.1](https://github.com/smur89/alta-typst/compare/v1.3.0...v1.3.1) (2026-06-16)


### Bug Fixes

* **readme:** release the CONTRIBUTING.md link fix as v1.3.1 ([#138](https://github.com/smur89/alta-typst/issues/138)) ([fc10448](https://github.com/smur89/alta-typst/commit/fc10448c1a8068779d3d0cc549b3acbfb326d727))

## [1.3.0](https://github.com/smur89/alta-typst/compare/v1.2.0...v1.3.0) (2026-06-16)


### Features

* switch profile-network icons to @preview/fontawesome ([#134](https://github.com/smur89/alta-typst/issues/134)) ([26ca051](https://github.com/smur89/alta-typst/commit/26ca051e2147ab51fecae2ba25c45cd59a440655))

## [1.2.0](https://github.com/smur89/alta-typst/compare/v1.1.1...v1.2.0) (2026-06-14)


### Features

* add preferences.qrCode for a header QR matrix linking to basics.url ([#126](https://github.com/smur89/alta-typst/issues/126)) ([e40f0d9](https://github.com/smur89/alta-typst/commit/e40f0d9f310bc253bbe35f24535418dfd0b70671))
* render JSON Resume references section ([#121](https://github.com/smur89/alta-typst/issues/121)) ([7473ee4](https://github.com/smur89/alta-typst/commit/7473ee4ce713cc1cb6932ccfddab3410f3df8ce7))

## [1.1.1](https://github.com/smur89/alta-typst/compare/v1.1.0...v1.1.1) (2026-06-14)


### Bug Fixes

* **package:** address Typst Universe package-check warnings ([#124](https://github.com/smur89/alta-typst/issues/124)) ([562f95d](https://github.com/smur89/alta-typst/commit/562f95d90ace09af2b5dfb2430eaa77297bf3f95))

## [1.1.0](https://github.com/smur89/alta-typst/compare/v1.0.0...v1.1.0) (2026-06-14)


### Features

* accept basics.location structured form ([#73](https://github.com/smur89/alta-typst/issues/73)) ([f7235b2](https://github.com/smur89/alta-typst/commit/f7235b25b2ca9da696bdd353c3c02610957bc4a1))
* add preferences.dateFormat for locale-aware ISO date rendering ([#76](https://github.com/smur89/alta-typst/issues/76)) ([d7344b8](https://github.com/smur89/alta-typst/commit/d7344b8bc4f015b1a2bcc8be9f8f6667fd60ae52))
* add preferences.maxRating for configurable language dot scale ([#69](https://github.com/smur89/alta-typst/issues/69)) ([f88f6e2](https://github.com/smur89/alta-typst/commit/f88f6e2ae52bd31cc120110f429f0823952062c3))
* add preferences.pageFooter for optional page footer ([#89](https://github.com/smur89/alta-typst/issues/89)) ([ede5f75](https://github.com/smur89/alta-typst/commit/ede5f7577780b6cd279cbe913dd2e7e57fad3506))
* add volunteer section ([#78](https://github.com/smur89/alta-typst/issues/78)) ([7a19d70](https://github.com/smur89/alta-typst/commit/7a19d706cb19e16290343eca4e3b08e84ff1802c))
* animated README hero — examples/preview.gif ([#110](https://github.com/smur89/alta-typst/issues/110)) ([3935835](https://github.com/smur89/alta-typst/commit/3935835bcc8ea839459d12d68713e0c51b7f8c4f))
* centred header image (stack above/below name) ([#67](https://github.com/smur89/alta-typst/issues/67)) ([f4a1978](https://github.com/smur89/alta-typst/commit/f4a1978d59b8919b2839f2f7e544b2e8e689de72))
* example_full demo, Universe template support, README features ([#119](https://github.com/smur89/alta-typst/issues/119)) ([54860b7](https://github.com/smur89/alta-typst/commit/54860b764706207997c1d07cb1a57b4acf1da7b9))
* export built-in palette presets ([#79](https://github.com/smur89/alta-typst/issues/79)) ([a1639d4](https://github.com/smur89/alta-typst/commit/a1639d4b6ea007644ffe2fe19bb808c79659d3d4))
* link education[].institution via education[].url ([#77](https://github.com/smur89/alta-typst/issues/77)) ([b2966b8](https://github.com/smur89/alta-typst/commit/b2966b8d285d8210b44bdaa6dc13a1b31031f2ee))
* render awards[].url as a link on the title ([#66](https://github.com/smur89/alta-typst/issues/66)) ([0c517c4](https://github.com/smur89/alta-typst/commit/0c517c4ec9984217fdadbfcf12a019c49bf0c72b))
* render basics.url in contact bar ([#75](https://github.com/smur89/alta-typst/issues/75)) ([3133548](https://github.com/smur89/alta-typst/commit/3133548e0e6868cd2eebf18348d6c0945e524e1f))
* render certificates[].date and certificates[].url ([#85](https://github.com/smur89/alta-typst/issues/85)) ([236a7cc](https://github.com/smur89/alta-typst/commit/236a7cc3ab47fe2c7cc20a13cd01ce773b986395))
* render education[].courses as pill tags ([#74](https://github.com/smur89/alta-typst/issues/74)) ([996fad0](https://github.com/smur89/alta-typst/commit/996fad0297ae16524b2e969579ccdc5be3269800))
* render meta.lastModified and enrich PDF metadata ([#92](https://github.com/smur89/alta-typst/issues/92)) ([f647eef](https://github.com/smur89/alta-typst/commit/f647eef39d54177531c1941dee26a19af8aee26a))
* render publications[].publisher ([#81](https://github.com/smur89/alta-typst/issues/81)) ([66328ca](https://github.com/smur89/alta-typst/commit/66328caa32691b7bc1b08793f7f04448a80e998f))
* render publications[].summary ([#80](https://github.com/smur89/alta-typst/issues/80)) ([09b24d6](https://github.com/smur89/alta-typst/commit/09b24d64df1f9398a6f8b06961bdd5f6f178c90f))
* render structured interests[] section ([#93](https://github.com/smur89/alta-typst/issues/93)) ([310c81e](https://github.com/smur89/alta-typst/commit/310c81e36a7f99db8b96cfc53778d3ef3a1b30d3)), closes [#45](https://github.com/smur89/alta-typst/issues/45)
* render work[].summary (and work[].description) ([#82](https://github.com/smur89/alta-typst/issues/82)) ([028a3c2](https://github.com/smur89/alta-typst/commit/028a3c2eb65251c62eb557b958690d439c1c1af5))
* render work[].url as a link on the company name ([#72](https://github.com/smur89/alta-typst/issues/72)) ([89d0a7a](https://github.com/smur89/alta-typst/commit/89d0a7a7f25c3d823be4b16ff8acfe6e683ed73e))
* support single-column layout via columnRatio=1 ([#101](https://github.com/smur89/alta-typst/issues/101)) ([bb65c26](https://github.com/smur89/alta-typst/commit/bb65c26a1637231c921a6bdbbe8c09e1df02a602))
* surface certificates[].issuer in the render ([#84](https://github.com/smur89/alta-typst/issues/84)) ([31e0e4e](https://github.com/smur89/alta-typst/commit/31e0e4e2a96bfe4489b430e802702c8077bcad90))


### Bug Fixes

* **header:** centre portrait above header when imagePosition is "center" ([#114](https://github.com/smur89/alta-typst/issues/114)) ([52a8cd5](https://github.com/smur89/alta-typst/commit/52a8cd555990f68950f54cfce3e43832a63703db))

## [1.0.0](https://github.com/smur89/alta-typst/compare/v0.3.3...v1.0.0) (2026-06-12)


### ⚠ BREAKING CHANGES

* rename skill() helper to rating() ([#65](https://github.com/smur89/alta-typst/issues/65))
* align label keys with JSON Resume section keys ([#62](https://github.com/smur89/alta-typst/issues/62))

### Features

* add basics.image circular portrait in the header ([#29](https://github.com/smur89/alta-typst/issues/29)) ([601e586](https://github.com/smur89/alta-typst/commit/601e586bfe2e5d96eb2f51391d1f32abb9797d36))
* align label keys with JSON Resume section keys ([#62](https://github.com/smur89/alta-typst/issues/62)) ([b33df8c](https://github.com/smur89/alta-typst/commit/b33df8c81a894be2b02ce58d03c00e5a5644f793))
* rename skill() helper to rating() ([#65](https://github.com/smur89/alta-typst/issues/65)) ([95a0aca](https://github.com/smur89/alta-typst/commit/95a0acaa733183ba11637b8a11843bb2a341a876))
* render JSON Resume awards section ([#28](https://github.com/smur89/alta-typst/issues/28)) ([b1125e9](https://github.com/smur89/alta-typst/commit/b1125e9d6504b4cce8086073f3f5c6656f6c801f))
* render JSON Resume projects section ([#27](https://github.com/smur89/alta-typst/issues/27)) ([c9fe93b](https://github.com/smur89/alta-typst/commit/c9fe93b23a90443e9d9873685d449b6884b10312))


### Bug Fixes

* address findings from repo-wide quality review ([#16](https://github.com/smur89/alta-typst/issues/16)) ([be32f4a](https://github.com/smur89/alta-typst/commit/be32f4a914b496ae52ad6b0a28f55099ecb1f8b6))

## [0.3.3](https://github.com/smur89/alta-typst/compare/v0.3.2...v0.3.3) (2026-06-11)


### Bug Fixes

* **ci:** force-push the submission branch so re-runs are idempotent ([#13](https://github.com/smur89/alta-typst/issues/13)) ([82bb1f0](https://github.com/smur89/alta-typst/commit/82bb1f005eb3fbbb01774f8b6aff59d9d64e5c06))

## [0.3.2](https://github.com/smur89/alta-typst/compare/v0.3.1...v0.3.2) (2026-06-11)


### Bug Fixes

* **ci:** drop explicit upstream remote add — gh sets it up on fork clone ([#11](https://github.com/smur89/alta-typst/issues/11)) ([be1907d](https://github.com/smur89/alta-typst/commit/be1907daed3968e6e00f450abd84c20cc2107373))

## [0.3.1](https://github.com/smur89/alta-typst/compare/v0.3.0...v0.3.1) (2026-06-11)


### Bug Fixes

* address typst-package-check feedback for 0.3.0 submission ([#7](https://github.com/smur89/alta-typst/issues/7)) ([9560452](https://github.com/smur89/alta-typst/commit/9560452bb6e0a85e26ae9add6c8f239147ea5fea))

## [0.3.0](https://github.com/smur89/alta-typst/compare/v0.2.0...v0.3.0) (2026-06-11)


### Features

* harden data model and add fixture test suite ([aa38b71](https://github.com/smur89/alta-typst/commit/aa38b71882d4fdb262666e78e441ac5e82accbe6))
* initial altacv template ([d42461b](https://github.com/smur89/alta-typst/commit/d42461b0d2e81f82835bcc54e75a899608b51544))
* initial altacv template ([b3de972](https://github.com/smur89/alta-typst/commit/b3de972bb34e7a6673ce1464662a8d6e207aa844))


### Bug Fixes

* add generic link icon for non-branded URLs ([b4ee28f](https://github.com/smur89/alta-typst/commit/b4ee28fac218353be2106faf2e858dabdbc24d01))
* drop stale _profile_networks from icon-registration error message ([a81ae38](https://github.com/smur89/alta-typst/commit/a81ae382b22ddd163328e61118b7a5609565e3ef))
* polish README, refresh example, and add developer profile icons ([d4109ec](https://github.com/smur89/alta-typst/commit/d4109ec13646bd82bb62d40b7bab272075d9f1c4))
* polish README, refresh example, and add developer profile icons ([3a93b7d](https://github.com/smur89/alta-typst/commit/3a93b7d90146f6e6fbc4a6402f2ab9dc603822b0))
* versioning ([bfce175](https://github.com/smur89/alta-typst/commit/bfce1759117b1caf6fd6aba0e0ac81e0b5e39d8d))

## [0.2.0](https://github.com/smur89/alta-typst/compare/altacv-v0.1.0...altacv-v0.2.0) (2026-06-11)


### Features

* harden data model and add fixture test suite ([aa38b71](https://github.com/smur89/alta-typst/commit/aa38b71882d4fdb262666e78e441ac5e82accbe6))
* initial altacv template ([d42461b](https://github.com/smur89/alta-typst/commit/d42461b0d2e81f82835bcc54e75a899608b51544))
* initial altacv template ([b3de972](https://github.com/smur89/alta-typst/commit/b3de972bb34e7a6673ce1464662a8d6e207aa844))
