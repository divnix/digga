# Pull Requests
If making a change to core, or adding a feature, please be sure to update the
relevant docs. Each directory contains its own README.md, which will
automatically be pulled into the [mdbook](https://devos.divnix.com). The book is
rendered on every change, so the docs should always be up to date.

We also use [BORS](https://bors.tech) to ensure that all pull requests pass the
test suite once at least one review is completed.

## Community PRs
While much of your work in this template may be idiosyncratic in nature. Anything
that might be generally useful to the broader NixOS community can be synced to
the `community` branch to provide a host of useful NixOS configurations available
"out of the box".

# Style
If you wish to contribute please follow these guidelines:

* format your code with [`nixpkgs-fmt`][nixpkgs-fmt]. The default devshell
  includes a pre-commit hook that does this for you.

* The commit message follows the same semantics as [nixpkgs][nixpkgs].
  * You can use a `#` symbol to specify ambiguities. For example,
  `develop#zsh: <rest of commit message>` would tell me that you're updating the
  `zsh` subprofile living under the `develop` profile.

[nixpkgs-fmt]: https://github.com/nix-community/nixpkgs-fmt
[nixpkgs]: https://github.com/NixOS/nixpkgs
