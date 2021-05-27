# Changelog

## [v0.10.0](https://github.com/divnix/devos/tree/v0.10.0) (2021-05-24)

**Implemented enhancements:**

- Providing an interface to nixpkgs.config [\#237](https://github.com/divnix/devos/issues/237)
- Making the user available in profiles [\#230](https://github.com/divnix/devos/issues/230)
- copy evaluation store paths to iso [\#195](https://github.com/divnix/devos/issues/195)
- Extract custom system builds from devosSystem out of lib [\#170](https://github.com/divnix/devos/issues/170)
- Allow setting of channel host-wide [\#117](https://github.com/divnix/devos/issues/117)
- alacritty: CSIu support [\#51](https://github.com/divnix/devos/issues/51)

**Fixed bugs:**

- Cachix timeouts + how to disable nrdxp cachix \(if needed\) [\#294](https://github.com/divnix/devos/issues/294)
- default.nix flake-compat is broken [\#285](https://github.com/divnix/devos/issues/285)
- All suites return "attribute missing" [\#282](https://github.com/divnix/devos/issues/282)
- nix is built two times [\#203](https://github.com/divnix/devos/issues/203)
- fix lib docs [\#166](https://github.com/divnix/devos/issues/166)

**Closed issues:**

- eliminate userFlakeNixOS [\#257](https://github.com/divnix/devos/issues/257)
- devos-as-library [\#214](https://github.com/divnix/devos/issues/214)

**Merged pull requests:**

- Update evalArgs to match the new planned API [\#239](https://github.com/divnix/devos/pull/239)

## [v0.9.0](https://github.com/divnix/devos/tree/v0.9.0) (2021-04-19)

**Implemented enhancements:**

- pin inputs into iso live registry [\#190](https://github.com/divnix/devos/issues/190)
- Pass 'self' to lib [\#169](https://github.com/divnix/devos/issues/169)
- doc: quickstart "ISO. What next?" [\#167](https://github.com/divnix/devos/issues/167)
- Integrate Android AOSP putting mobile under control [\#149](https://github.com/divnix/devos/issues/149)
- Inoculate host identity on first use [\#132](https://github.com/divnix/devos/issues/132)
- kubenix support [\#130](https://github.com/divnix/devos/issues/130)
- Improve Home Manager support: profiles/suites, modules, extern, flake outputs [\#119](https://github.com/divnix/devos/issues/119)
- Local CA \(between hosts\) [\#104](https://github.com/divnix/devos/issues/104)
- Q5: git annex for machine state [\#68](https://github.com/divnix/devos/issues/68)
- name space ./pkgs overlays [\#60](https://github.com/divnix/devos/issues/60)
- remap global keys easily [\#57](https://github.com/divnix/devos/issues/57)
- make pass state part of this repo's structure [\#56](https://github.com/divnix/devos/issues/56)
- Incorporate ./shells [\#38](https://github.com/divnix/devos/issues/38)
- Encrypt with \(r\)age [\#37](https://github.com/divnix/devos/issues/37)

**Fixed bugs:**

- `pathsToImportedAttrs` does not accept directories [\#221](https://github.com/divnix/devos/issues/221)
- Cachix caches aren't added to the configuration [\#208](https://github.com/divnix/devos/issues/208)
- Issues with current changelog workflow [\#205](https://github.com/divnix/devos/issues/205)
- iso: systemd service startup [\#194](https://github.com/divnix/devos/issues/194)
- Help adding easy-hls-nix to devos [\#174](https://github.com/divnix/devos/issues/174)
- `flk update` fails because of obsolete flag [\#159](https://github.com/divnix/devos/issues/159)
- Expected that not all packages are exported? [\#151](https://github.com/divnix/devos/issues/151)
- Segmentation fault when generating iso [\#150](https://github.com/divnix/devos/issues/150)

**Documentation:**

- doc: split iso [\#193](https://github.com/divnix/devos/issues/193)
- lib: can depend on pkgs \(a la nixpkgs\#pkgs/pkgs-lib\) [\#147](https://github.com/divnix/devos/pull/147)

**Closed issues:**

- FRRouting router implementation [\#154](https://github.com/divnix/devos/issues/154)
- ARM aarch64 Support [\#72](https://github.com/divnix/devos/issues/72)

## [v0.8.0](https://github.com/divnix/devos/tree/v0.8.0) (2021-03-02)

**Implemented enhancements:**

- semi automatic update for /pkgs [\#118](https://github.com/divnix/devos/issues/118)
- Home-manager external modules from flakes [\#106](https://github.com/divnix/devos/issues/106)

**Fixed bugs:**

- My emacsGcc overlay is not working  [\#146](https://github.com/divnix/devos/issues/146)
- local flake registry freezes branches [\#142](https://github.com/divnix/devos/issues/142)
- nixos-option no longer works after collect garbage [\#138](https://github.com/divnix/devos/issues/138)
- Profiles imports are brittle, causing failure if imported twice [\#136](https://github.com/divnix/devos/issues/136)

## [0.7.0](https://github.com/divnix/devos/tree/0.7.0) (2021-02-20)

**Implemented enhancements:**

- add zoxide [\#53](https://github.com/divnix/devos/issues/53)
- Multiarch support? [\#17](https://github.com/divnix/devos/issues/17)
- initial multiArch support [\#18](https://github.com/divnix/devos/pull/18)

**Fixed bugs:**

- Missing shebang from flk.sh [\#131](https://github.com/divnix/devos/issues/131)
- Rename Meta Issue [\#128](https://github.com/divnix/devos/issues/128)
- specialisations break the `system` argument [\#46](https://github.com/divnix/devos/issues/46)
- Revert "Add extraArgs to lib.nixosSystem call to add system args." [\#47](https://github.com/divnix/devos/pull/47)

**Documentation:**

- update home-manager urls [\#62](https://github.com/divnix/devos/pull/62)

**Closed issues:**

- add github action for cachix build ci [\#59](https://github.com/divnix/devos/issues/59)

## [12052020](https://github.com/divnix/devos/tree/12052020) (2020-12-06)

## [07092020](https://github.com/divnix/devos/tree/07092020) (2020-07-09)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
