# Changelog

## [1.1.0](https://github.com/smur89/alta-typst/compare/v1.0.0...v1.1.0) (2026-06-14)


### Features

* accept basics.location structured form ([#73](https://github.com/smur89/alta-typst/issues/73)) ([f7235b2](https://github.com/smur89/alta-typst/commit/f7235b25b2ca9da696bdd353c3c02610957bc4a1))
* add preferences.maxRating for configurable language dot scale ([#69](https://github.com/smur89/alta-typst/issues/69)) ([f88f6e2](https://github.com/smur89/alta-typst/commit/f88f6e2ae52bd31cc120110f429f0823952062c3))
* add volunteer section ([#78](https://github.com/smur89/alta-typst/issues/78)) ([7a19d70](https://github.com/smur89/alta-typst/commit/7a19d706cb19e16290343eca4e3b08e84ff1802c))
* centred header image (stack above/below name) ([#67](https://github.com/smur89/alta-typst/issues/67)) ([f4a1978](https://github.com/smur89/alta-typst/commit/f4a1978d59b8919b2839f2f7e544b2e8e689de72))
* link education[].institution via education[].url ([#77](https://github.com/smur89/alta-typst/issues/77)) ([b2966b8](https://github.com/smur89/alta-typst/commit/b2966b8d285d8210b44bdaa6dc13a1b31031f2ee))
* render awards[].url as a link on the title ([#66](https://github.com/smur89/alta-typst/issues/66)) ([0c517c4](https://github.com/smur89/alta-typst/commit/0c517c4ec9984217fdadbfcf12a019c49bf0c72b))
* render basics.url in contact bar ([#75](https://github.com/smur89/alta-typst/issues/75)) ([3133548](https://github.com/smur89/alta-typst/commit/3133548e0e6868cd2eebf18348d6c0945e524e1f))
* render certificates[].date and certificates[].url ([#85](https://github.com/smur89/alta-typst/issues/85)) ([236a7cc](https://github.com/smur89/alta-typst/commit/236a7cc3ab47fe2c7cc20a13cd01ce773b986395))
* render education[].courses as pill tags ([#74](https://github.com/smur89/alta-typst/issues/74)) ([996fad0](https://github.com/smur89/alta-typst/commit/996fad0297ae16524b2e969579ccdc5be3269800))
* render meta.lastModified and enrich PDF metadata ([#92](https://github.com/smur89/alta-typst/issues/92)) ([f647eef](https://github.com/smur89/alta-typst/commit/f647eef39d54177531c1941dee26a19af8aee26a))
* render publications[].summary ([#80](https://github.com/smur89/alta-typst/issues/80)) ([09b24d6](https://github.com/smur89/alta-typst/commit/09b24d64df1f9398a6f8b06961bdd5f6f178c90f))
* render structured interests[] section ([#93](https://github.com/smur89/alta-typst/issues/93)) ([310c81e](https://github.com/smur89/alta-typst/commit/310c81e36a7f99db8b96cfc53778d3ef3a1b30d3)), closes [#45](https://github.com/smur89/alta-typst/issues/45)
* render work[].summary (and work[].description) ([#82](https://github.com/smur89/alta-typst/issues/82)) ([028a3c2](https://github.com/smur89/alta-typst/commit/028a3c2eb65251c62eb557b958690d439c1c1af5))
* render work[].url as a link on the company name ([#72](https://github.com/smur89/alta-typst/issues/72)) ([89d0a7a](https://github.com/smur89/alta-typst/commit/89d0a7a7f25c3d823be4b16ff8acfe6e683ed73e))

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
