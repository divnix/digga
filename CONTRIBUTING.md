# Pull Requests

While much of your work in this template may be idiosyncratic in nature. Anything
that might be generally useful to the broader NixOS community can be synced to
the `template` branch to provide a host of useful NixOS configurations available
"out of the box". If you wish to contribute such an expression please follow
these guidelines:

* format your code with [`nixfmt`][nixfmt]
* The commit message follows the same semantics as [nixpkgs][nixpkgs].
  * You can use a `#` symbol to specify ambiguities. For example,
  `develop#zsh: <rest of commit message>` would tell me that your updating the
  `zsh` subprofile living under the `develop` profile.

[nixfmt]: https://github.com/serokell/nixfmt
[nixpkgs]: https://github.com/NixOS/nixpkgs
