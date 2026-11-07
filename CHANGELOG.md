# Changelog

## [1.9.0](https://github.com/smur89/alta-typst/compare/v1.8.0...v1.9.0) (2026-11-07)


### Features

* a refreshed layout: each entry leads with its role, with its date and location at the right edge; quieter section headings, a lighter section rule and set-apart group headings; contacts and profiles on separate lines, URLs without their scheme; the objective under the tagline; a publication's source and date on one line, and an education score on its own; pills for skills only ([[#291](https://github.com/smur89/alta-typst/issues/291)](https://github.com/smur89/alta-typst/issues/291), [[#292](https://github.com/smur89/alta-typst/issues/292)](https://github.com/smur89/alta-typst/issues/292), [[#293](https://github.com/smur89/alta-typst/issues/293)](https://github.com/smur89/alta-typst/issues/293), [[#364](https://github.com/smur89/alta-typst/issues/364)](https://github.com/smur89/alta-typst/issues/364)) ([d02b661](https://github.com/smur89/alta-typst/commit/d02b6610d8e12c823c5b4714d2f0e83269b2ebe9))
* accessibility: the date and location icons have alt text, and the headings nest under the name, checked as PDF/UA in CI ([[#316](https://github.com/smur89/alta-typst/issues/316)](https://github.com/smur89/alta-typst/issues/316), [[#341](https://github.com/smur89/alta-typst/issues/341)](https://github.com/smur89/alta-typst/issues/341)) ([adca74f](https://github.com/smur89/alta-typst/commit/adca74f9cbf3e766477cddd26251fed24bc62b4d))
* add field 'keywords' for work/volunteer (like projects) ([#215](https://github.com/smur89/alta-typst/issues/215)) ([af49519](https://github.com/smur89/alta-typst/commit/af49519a7ec19e6300a580b010aa16342ea418af))
* more of JSON Resume: the 1.7.0 fields and `custom.altacv` extensions in a `resume.json` (gairm-import 0.10.1), `work[]` and `volunteer[]` keywords, `skills[].level` and `education[].area` ([[#215](https://github.com/smur89/alta-typst/issues/215)](https://github.com/smur89/alta-typst/issues/215), [[#321](https://github.com/smur89/alta-typst/issues/321)](https://github.com/smur89/alta-typst/issues/321), [[#324](https://github.com/smur89/alta-typst/issues/324)](https://github.com/smur89/alta-typst/issues/324), [[#397](https://github.com/smur89/alta-typst/issues/397)](https://github.com/smur89/alta-typst/issues/397)) ([a30f145](https://github.com/smur89/alta-typst/commit/a30f1457848344620a6127c995387f0a396ca95e))
* new options and icons: square and rounded photo shapes, icons by project type (`project-icons`) and publication type (`publication-icons`), ORCID and more profile networks, `owner-names` to bold you under other spellings of your name, `print-full-urls` for unlinked contacts, and `page-footer: auto` ([[#267](https://github.com/smur89/alta-typst/issues/267)](https://github.com/smur89/alta-typst/issues/267), [[#288](https://github.com/smur89/alta-typst/issues/288)](https://github.com/smur89/alta-typst/issues/288), [[#292](https://github.com/smur89/alta-typst/issues/292)](https://github.com/smur89/alta-typst/issues/292), [[#313](https://github.com/smur89/alta-typst/issues/313)](https://github.com/smur89/alta-typst/issues/313), [[#315](https://github.com/smur89/alta-typst/issues/315)](https://github.com/smur89/alta-typst/issues/315), [[#317](https://github.com/smur89/alta-typst/issues/317)](https://github.com/smur89/alta-typst/issues/317), [[#344](https://github.com/smur89/alta-typst/issues/344)](https://github.com/smur89/alta-typst/issues/344), [[#348](https://github.com/smur89/alta-typst/issues/348)](https://github.com/smur89/alta-typst/issues/348)) ([f3ac7f7](https://github.com/smur89/alta-typst/commit/f3ac7f793143343ad9a6a749700f4d531d9393e1))
* options are kebab-case and take Typst's own values (`right`, `6em`, `center`) where they took names in strings ([[#386](https://github.com/smur89/alta-typst/issues/386)](https://github.com/smur89/alta-typst/issues/386), [[#389](https://github.com/smur89/alta-typst/issues/389)](https://github.com/smur89/alta-typst/issues/389)) ([e734a31](https://github.com/smur89/alta-typst/commit/e734a31ffc7c65e7ab5f88d8a4148ac17e85c7b2))
* show rules reach every part of the CV through part labels (contacts, dates, locations, rating dots, keywords, dividers and more), so a show rule can, for example, draw keywords as pills ([[#325](https://github.com/smur89/alta-typst/issues/325)](https://github.com/smur89/alta-typst/issues/325), [[#328](https://github.com/smur89/alta-typst/issues/328)](https://github.com/smur89/alta-typst/issues/328), [[#329](https://github.com/smur89/alta-typst/issues/329)](https://github.com/smur89/alta-typst/issues/329), [[#330](https://github.com/smur89/alta-typst/issues/330)](https://github.com/smur89/alta-typst/issues/330), [[#338](https://github.com/smur89/alta-typst/issues/338)](https://github.com/smur89/alta-typst/issues/338), [[#343](https://github.com/smur89/alta-typst/issues/343)](https://github.com/smur89/alta-typst/issues/343), [[#347](https://github.com/smur89/alta-typst/issues/347)](https://github.com/smur89/alta-typst/issues/347), [[#356](https://github.com/smur89/alta-typst/issues/356)](https://github.com/smur89/alta-typst/issues/356), [[#358](https://github.com/smur89/alta-typst/issues/358)](https://github.com/smur89/alta-typst/issues/358)) ([84fc9ba](https://github.com/smur89/alta-typst/commit/84fc9ba7caba179064e0d697c47855b6d3f93668))


### Bug Fixes

* `#import "@preview/altacv:…": *` no longer brings in internal helpers ([[#286](https://github.com/smur89/alta-typst/issues/286)](https://github.com/smur89/alta-typst/issues/286)) ([bff8560](https://github.com/smur89/alta-typst/commit/bff8560ef260b1c69af6037327af34eed21ea0c4))
* a skill or interest group without a name renders, and so does a language without a fluency ([[#409](https://github.com/smur89/alta-typst/issues/409)](https://github.com/smur89/alta-typst/issues/409), [[#411](https://github.com/smur89/alta-typst/issues/411)](https://github.com/smur89/alta-typst/issues/411)) ([3bdcdcf](https://github.com/smur89/alta-typst/commit/3bdcdcf82349722ada48c2ffed72af8353cddf5a))
* every CV error is raised before rendering, in one form ("X must be Y, got: Z"): wrong-typed fields, column lists and location values get a guided error where they crashed, and a JSON `null` reads as absent ([[#282](https://github.com/smur89/alta-typst/issues/282)](https://github.com/smur89/alta-typst/issues/282), [[#283](https://github.com/smur89/alta-typst/issues/283)](https://github.com/smur89/alta-typst/issues/283), [[#287](https://github.com/smur89/alta-typst/issues/287)](https://github.com/smur89/alta-typst/issues/287), [[#401](https://github.com/smur89/alta-typst/issues/401)](https://github.com/smur89/alta-typst/issues/401)) ([f13ed93](https://github.com/smur89/alta-typst/commit/f13ed9352af6ff69a031e880397418b7aa3b9d0c))
* inline icons and rating dots sit centred on the text, Font Awesome 7 glyphs no longer sink, and a glyph replacing a rating dot takes the dot's colour ([[#211](https://github.com/smur89/alta-typst/issues/211)](https://github.com/smur89/alta-typst/issues/211), [[#320](https://github.com/smur89/alta-typst/issues/320)](https://github.com/smur89/alta-typst/issues/320)) ([0db7c41](https://github.com/smur89/alta-typst/commit/0db7c41ea2e32e583e3588213389105e3ebae949))

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
