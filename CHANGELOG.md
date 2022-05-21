# Changelog

## [Unreleased]

### Fixed

- **BREAKING CHANGE:** Remove exported overlays to unblock usage of `emacs-overlay` [\#469](https://github.com/divnix/digga/pull/469)

## [v0.11.0](https://github.com/divnix/digga/tree/v0.11.0) (2022-04-01)

**Implemented enhancements:**

- A quick question. [\#428](https://github.com/divnix/digga/issues/428)
- infinite recursion error related to whether a git repo exists \#408 [\#413](https://github.com/divnix/digga/issues/413)
- Support aarch64-darwin  [\#335](https://github.com/divnix/digga/issues/335)
- pkgs in home-manager profiles [\#309](https://github.com/divnix/digga/issues/309)
- Allow the same user profile to behave differently based on hostname [\#308](https://github.com/divnix/digga/issues/308)
- Home-manager inside ./modules or ./profiles to set user settings in a user agnostic way [\#303](https://github.com/divnix/digga/issues/303)
- Better package source fetching [\#299](https://github.com/divnix/digga/issues/299)

**Fixed bugs:**

- "Check & Cachix" workflow failing on `main` [\#443](https://github.com/divnix/digga/issues/443)
- Agenix secrets are no longer decrypted to /run/secrets but to a changing directory under /run/agenix.d [\#425](https://github.com/divnix/digga/issues/425)
- core dump on build with fresh clone [\#411](https://github.com/divnix/digga/issues/411)
- Error following quickstart guide [\#408](https://github.com/divnix/digga/issues/408)
- error: unrecognised flag '--extra-experimental-features' [\#406](https://github.com/divnix/digga/issues/406)
- `error: attribute 'patchedNix' missing` after calling `bud update` [\#404](https://github.com/divnix/digga/issues/404)
- cd devos; nix-shell = error: infinite recursion encountered [\#394](https://github.com/divnix/digga/issues/394)
- Fresh installation fails [\#389](https://github.com/divnix/digga/issues/389)
- Bud command does not work due to error "This script must be run either from the flake's devshell" [\#382](https://github.com/divnix/digga/issues/382)
- Renaming default user [\#381](https://github.com/divnix/digga/issues/381)
- Dead link on devos.divnix.com [\#377](https://github.com/divnix/digga/issues/377)
- hash mismatch in fixed-output derivation `fix-follows.diff` [\#376](https://github.com/divnix/digga/issues/376)
- initial install on darwin ends with errors relating to unknown `hostname` option [\#375](https://github.com/divnix/digga/issues/375)
- Primary branch name in CI configurations points to `main` but `main` was renamed to `master` [\#369](https://github.com/divnix/digga/issues/369)
- nix fails to build [\#359](https://github.com/divnix/digga/issues/359)
- After implementation of digga's `rakeLeaves`, can't rebuild in the presence of `\*/modules-list.nix` [\#351](https://github.com/divnix/digga/issues/351)
- local flake registry freezes NUR input [\#347](https://github.com/divnix/digga/issues/347)
- home-manager.users.\<user\>.inputs does not exist [\#336](https://github.com/divnix/digga/issues/336)
- Overlays don't seem to always be applied in the right order [\#318](https://github.com/divnix/digga/issues/318)
- flake is not a recognized command [\#315](https://github.com/divnix/digga/issues/315)
- replacing and disabling modules with new api [\#310](https://github.com/divnix/digga/issues/310)
- FYI nix unstable is broken right now, avoid updating [\#296](https://github.com/divnix/digga/issues/296)
- Core profile optional \(doc\) [\#295](https://github.com/divnix/digga/issues/295)
- error creating statement 'insert or replace into realisations" broke nix installation on update [\#241](https://github.com/divnix/digga/issues/241)
- flk install broken since 3 days worth of nix update [\#204](https://github.com/divnix/digga/issues/204)
- incomplete substituters file [\#98](https://github.com/divnix/digga/issues/98)

**Closed issues:**

- \[nixpkgs\]: nix-direnv no longer needs override [\#415](https://github.com/divnix/digga/issues/415)
- \[ \<put the upstream project\> \]: \<topic\> [\#324](https://github.com/divnix/digga/issues/324)
- greetd minimalism [\#153](https://github.com/divnix/digga/issues/153)
- Toward a stable filesystem api [\#152](https://github.com/divnix/digga/issues/152)
- using cookiecutter or similar tools to bootstrap the template [\#16](https://github.com/divnix/digga/issues/16)

## [v0.10.0](https://github.com/divnix/digga/tree/v0.10.0) (2021-05-24)

**Implemented enhancements:**

- Providing an interface to nixpkgs.config [\#237](https://github.com/divnix/digga/issues/237)
- Making the user available in profiles [\#230](https://github.com/divnix/digga/issues/230)
- copy evaluation store paths to iso [\#195](https://github.com/divnix/digga/issues/195)
- Extract custom system builds from devosSystem out of lib [\#170](https://github.com/divnix/digga/issues/170)
- Allow setting of channel host-wide [\#117](https://github.com/divnix/digga/issues/117)
- alacritty: CSIu support [\#51](https://github.com/divnix/digga/issues/51)

**Fixed bugs:**

- Cachix timeouts + how to disable nrdxp cachix \(if needed\) [\#294](https://github.com/divnix/digga/issues/294)
- default.nix flake-compat is broken [\#285](https://github.com/divnix/digga/issues/285)
- All suites return "attribute missing" [\#282](https://github.com/divnix/digga/issues/282)
- nix is built two times [\#203](https://github.com/divnix/digga/issues/203)
- fix lib docs [\#166](https://github.com/divnix/digga/issues/166)

**Closed issues:**

- eliminate userFlakeNixOS [\#257](https://github.com/divnix/digga/issues/257)
- devos-as-library [\#214](https://github.com/divnix/digga/issues/214)

**Merged pull requests:**

- Update evalArgs to match the new planned API [\#239](https://github.com/divnix/digga/pull/239)

## [v0.9.0](https://github.com/divnix/digga/tree/v0.9.0) (2021-04-19)

**Implemented enhancements:**

- pin inputs into iso live registry [\#190](https://github.com/divnix/digga/issues/190)
- Pass 'self' to lib [\#169](https://github.com/divnix/digga/issues/169)
- doc: quickstart "ISO. What next?" [\#167](https://github.com/divnix/digga/issues/167)
- Integrate Android AOSP putting mobile under control [\#149](https://github.com/divnix/digga/issues/149)
- Inoculate host identity on first use [\#132](https://github.com/divnix/digga/issues/132)
- kubenix support [\#130](https://github.com/divnix/digga/issues/130)
- Improve Home Manager support: profiles/suites, modules, extern, flake outputs [\#119](https://github.com/divnix/digga/issues/119)
- Local CA \(between hosts\) [\#104](https://github.com/divnix/digga/issues/104)
- Q5: git annex for machine state [\#68](https://github.com/divnix/digga/issues/68)
- name space ./pkgs overlays [\#60](https://github.com/divnix/digga/issues/60)
- remap global keys easily [\#57](https://github.com/divnix/digga/issues/57)
- make pass state part of this repo's structure [\#56](https://github.com/divnix/digga/issues/56)
- Incorporate ./shells [\#38](https://github.com/divnix/digga/issues/38)
- Encrypt with \(r\)age [\#37](https://github.com/divnix/digga/issues/37)

**Fixed bugs:**

- `pathsToImportedAttrs` does not accept directories [\#221](https://github.com/divnix/digga/issues/221)
- Cachix caches aren't added to the configuration [\#208](https://github.com/divnix/digga/issues/208)
- Issues with current changelog workflow [\#205](https://github.com/divnix/digga/issues/205)
- iso: systemd service startup [\#194](https://github.com/divnix/digga/issues/194)
- Help adding easy-hls-nix to devos [\#174](https://github.com/divnix/digga/issues/174)
- `flk update` fails because of obsolete flag [\#159](https://github.com/divnix/digga/issues/159)
- Expected that not all packages are exported? [\#151](https://github.com/divnix/digga/issues/151)
- Segmentation fault when generating iso [\#150](https://github.com/divnix/digga/issues/150)

**Documentation:**

- doc: split iso [\#193](https://github.com/divnix/digga/issues/193)
- lib: can depend on pkgs \(a la nixpkgs\#pkgs/pkgs-lib\) [\#147](https://github.com/divnix/digga/pull/147)

**Closed issues:**

- FRRouting router implementation [\#154](https://github.com/divnix/digga/issues/154)
- ARM aarch64 Support [\#72](https://github.com/divnix/digga/issues/72)

## [v0.8.0](https://github.com/divnix/digga/tree/v0.8.0) (2021-03-02)

**Implemented enhancements:**

- semi automatic update for /pkgs [\#118](https://github.com/divnix/digga/issues/118)
- Home-manager external modules from flakes [\#106](https://github.com/divnix/digga/issues/106)

**Fixed bugs:**

- My emacsGcc overlay is not working  [\#146](https://github.com/divnix/digga/issues/146)
- local flake registry freezes branches [\#142](https://github.com/divnix/digga/issues/142)
- nixos-option no longer works after collect garbage [\#138](https://github.com/divnix/digga/issues/138)
- Profiles imports are brittle, causing failure if imported twice [\#136](https://github.com/divnix/digga/issues/136)

## [0.7.0](https://github.com/divnix/digga/tree/0.7.0) (2021-02-20)

**Implemented enhancements:**

- add zoxide [\#53](https://github.com/divnix/digga/issues/53)
- Multiarch support? [\#17](https://github.com/divnix/digga/issues/17)
- initial multiArch support [\#18](https://github.com/divnix/digga/pull/18)

**Fixed bugs:**

- Missing shebang from flk.sh [\#131](https://github.com/divnix/digga/issues/131)
- Rename Meta Issue [\#128](https://github.com/divnix/digga/issues/128)
- specialisations break the `system` argument [\#46](https://github.com/divnix/digga/issues/46)
- Revert "Add extraArgs to lib.nixosSystem call to add system args." [\#47](https://github.com/divnix/digga/pull/47)

**Documentation:**

- update home-manager urls [\#62](https://github.com/divnix/digga/pull/62)

**Closed issues:**

- add github action for cachix build ci [\#59](https://github.com/divnix/digga/issues/59)

## [12052020](https://github.com/divnix/digga/tree/12052020) (2020-12-06)

## [07092020](https://github.com/divnix/digga/tree/07092020) (2020-07-09)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
