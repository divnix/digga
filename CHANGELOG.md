# Changelog

## [Unreleased](https://github.com/divnix/devos/tree/HEAD)

**Fixed bugs:**

- `flk update` fails because of obsolete flag [\#159](https://github.com/divnix/devos/issues/159)
- Expected that not all packages are exported? [\#151](https://github.com/divnix/devos/issues/151)
- Segmentation fault when generating iso [\#150](https://github.com/divnix/devos/issues/150)

**Documentation:**

- lib: can depend on pkgs \(a la nixpkgs\#pkgs/pkgs-lib\) [\#147](https://github.com/divnix/devos/pull/147)

**Closed issues:**

- mn alias: sk: command not found \(core\) [\#162](https://github.com/divnix/devos/issues/162)

## [v0.8.0](https://github.com/divnix/devos/tree/v0.8.0) (2021-03-02)

**Implemented enhancements:**

- semi automatic update for /pkgs [\#118](https://github.com/divnix/devos/issues/118)
- Home-manager external modules from flakes [\#106](https://github.com/divnix/devos/issues/106)

**Fixed bugs:**

- My emacsGcc overlay is not working  [\#146](https://github.com/divnix/devos/issues/146)
- local flake registry freezes branches [\#142](https://github.com/divnix/devos/issues/142)
- nixos-option no longer works after collect garbage [\#138](https://github.com/divnix/devos/issues/138)
- Profiles imports are brittle, causing failure if imported twice [\#136](https://github.com/divnix/devos/issues/136)

**Merged pull requests:**

- hosts: fix \#142 [\#143](https://github.com/divnix/devos/pull/143)
- profiles: simplify profiles to suites [\#139](https://github.com/divnix/devos/pull/139)
- pkgs: automatic source management [\#135](https://github.com/divnix/devos/pull/135)

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

- Patched nix causes problems with config using nixos-unstable [\#126](https://github.com/divnix/devos/issues/126)
- devshell changes [\#124](https://github.com/divnix/devos/issues/124)
- Following readme instructions does not work from NixOS [\#123](https://github.com/divnix/devos/issues/123)
- process information is hidden by default [\#115](https://github.com/divnix/devos/issues/115)
- Hibernation is disabled by default [\#114](https://github.com/divnix/devos/issues/114)
- Prepare for new default branch `core` [\#112](https://github.com/divnix/devos/issues/112)
- commit hook and deleting file [\#110](https://github.com/divnix/devos/issues/110)
- nix path should contain nixpkgs [\#107](https://github.com/divnix/devos/issues/107)
- Make bare \(on fork\) [\#100](https://github.com/divnix/devos/issues/100)
- enable redistributable firmware by default [\#92](https://github.com/divnix/devos/issues/92)
- Home manager on Non-nixos systems [\#83](https://github.com/divnix/devos/issues/83)
- implement apps as fallback or not at all [\#79](https://github.com/divnix/devos/issues/79)
- ovoverlay import mechanics don't seem to allow file name attribute discrepancy and also do not distinguish between nixos and master [\#76](https://github.com/divnix/devos/issues/76)
- host specific externModules [\#70](https://github.com/divnix/devos/issues/70)
- home-manager-path error, rm no operands [\#69](https://github.com/divnix/devos/issues/69)
- Can't add custom pkgs to systemPackages. [\#65](https://github.com/divnix/devos/issues/65)
- Build installer iso from unstable nixpkgs. [\#63](https://github.com/divnix/devos/issues/63)
- add github action for cachix build ci [\#59](https://github.com/divnix/devos/issues/59)
- Adding and using the nixos-hardware flake [\#44](https://github.com/divnix/devos/issues/44)
- NUR support [\#40](https://github.com/divnix/devos/issues/40)
- cannot look up '\<nixpkgs\>' in pure evaluation mode [\#30](https://github.com/divnix/devos/issues/30)
- New generation on rebuild? [\#27](https://github.com/divnix/devos/issues/27)
- Is home.url in flake.nix in need of an update? [\#24](https://github.com/divnix/devos/issues/24)
- home-manager activate segmentation fault following readme.md upon rebuild NixOS test [\#22](https://github.com/divnix/devos/issues/22)
- Unable to use custom pkgs in home.packages [\#21](https://github.com/divnix/devos/issues/21)
- Understanding Flakes [\#19](https://github.com/divnix/devos/issues/19)
- using cookiecutter or similar tools to bootstrap the template [\#16](https://github.com/divnix/devos/issues/16)
- Command `rebuild` broken with newest Nix: unrecognised flag '-c' [\#13](https://github.com/divnix/devos/issues/13)
- Upstream nixpkgs? [\#12](https://github.com/divnix/devos/issues/12)
- Cannot obtain loader entries [\#11](https://github.com/divnix/devos/issues/11)
- Run `nix-shell` got `error: invalid character '/' in name 'opt/nix.conf'` [\#10](https://github.com/divnix/devos/issues/10)
- how to use NUR? [\#8](https://github.com/divnix/devos/issues/8)
- bad idea to have make-linux-fast-again by default? [\#6](https://github.com/divnix/devos/issues/6)
- Permission denied [\#4](https://github.com/divnix/devos/issues/4)
- error: flake '/home/bbigras/nixflk' does not provide attribute 'nixosConfigurations.new\_host.config.system.build.toplevel' [\#2](https://github.com/divnix/devos/issues/2)

**Merged pull requests:**

- deploy-rs: init support [\#120](https://github.com/divnix/devos/pull/120)
- core: fix \#115 [\#116](https://github.com/divnix/devos/pull/116)
- doc: begin work on new documentation [\#113](https://github.com/divnix/devos/pull/113)
- profiles: add concept of suites [\#109](https://github.com/divnix/devos/pull/109)
- hosts: add nixpkgs to NIX\_PATH [\#108](https://github.com/divnix/devos/pull/108)
- shell: use devshell-native pre-commit hooks [\#103](https://github.com/divnix/devos/pull/103)
- host: add deault implementation for system.build.isoImage target \(per… [\#102](https://github.com/divnix/devos/pull/102)
- Revert "Add nrdxp cachix to substituter flake list" [\#99](https://github.com/divnix/devos/pull/99)
- nixos-hardware: use the flake instead of a path [\#96](https://github.com/divnix/devos/pull/96)
- flake/host: add nixos-hardware [\#95](https://github.com/divnix/devos/pull/95)
- hosts: enable redistributable firmware by default [\#94](https://github.com/divnix/devos/pull/94)
- users: Initial home-manager only configurations\(non-nixos systems\) [\#93](https://github.com/divnix/devos/pull/93)
- lock: fix flake util refs [\#90](https://github.com/divnix/devos/pull/90)
- flake: remove apps to reduce complexity [\#88](https://github.com/divnix/devos/pull/88)
- Fix realod [\#87](https://github.com/divnix/devos/pull/87)
- Shell: pass flags to iso build [\#84](https://github.com/divnix/devos/pull/84)
- Hosts: fix mod override [\#82](https://github.com/divnix/devos/pull/82)
- shell: add `flk up` command [\#81](https://github.com/divnix/devos/pull/81)
- Little hint [\#80](https://github.com/divnix/devos/pull/80)
- Don't evaluate overlays on master [\#78](https://github.com/divnix/devos/pull/78)
- Evaluate exported pkgs against repo baseline nixos [\#77](https://github.com/divnix/devos/pull/77)
- Add nrdxp cachix to substituter flake list [\#71](https://github.com/divnix/devos/pull/71)
- use `flattenTreeSystem` for `packages` output [\#67](https://github.com/divnix/devos/pull/67)
- Make modules overridable [\#66](https://github.com/divnix/devos/pull/66)
- ref: remove overlay xref to pkgs [\#61](https://github.com/divnix/devos/pull/61)
- Use mkDevShell for shell.nix [\#54](https://github.com/divnix/devos/pull/54)
- Add an `apps` output attribute set [\#49](https://github.com/divnix/devos/pull/49)
- chore: add editorconfig [\#48](https://github.com/divnix/devos/pull/48)
- flake: add `externModules` list [\#45](https://github.com/divnix/devos/pull/45)
- Add NUR support [\#43](https://github.com/divnix/devos/pull/43)
- flake: clean up by moving implementation to utils [\#42](https://github.com/divnix/devos/pull/42)
- home-manager: fix trying to import \<nixpkgs\> [\#33](https://github.com/divnix/devos/pull/33)
- shell: alias rebuild to nixos rebuild [\#29](https://github.com/divnix/devos/pull/29)
- DOC.md: Fix declaration typo [\#26](https://github.com/divnix/devos/pull/26)
- update to 20.09 to fix segfault [\#25](https://github.com/divnix/devos/pull/25)
- Add extraArgs to lib.nixosSystem call to add system args [\#23](https://github.com/divnix/devos/pull/23)
- .gitattributes: match the entire secrets/\*\* subtree [\#20](https://github.com/divnix/devos/pull/20)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
