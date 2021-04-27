# Testing

Testing is always an important aspect of any software development project, and
NixOS offers some incredibly powerful tools to write tests for your
configuration, and, optionally, run them in
[CI](./integrations/hercules.md).

## Lib Tests
You can easily write tests for your own library functions in the
lib/___tests/lib.nix___ file and they will be run on every `nix flake check` or
during a CI run.

## Unit Tests
Unit tests are can be created from regular derivations, and they can do
almost anything you can imagine. By convention, it is best to test your
packages during their [check phase][check]. All packages and their tests will
be built during CI.

## Integration Tests
You can write integration tests for one or more NixOS VMs that can,
optionally, be networked together, and yes, it's as awesome as it sounds!

Be sure to use the `mkTest` function, in the [___tests/default.nix___][default]
which wraps the official [testing-python][testing-python] function to ensure
that the system is setup exactly as it is for a bare DevOS system. There are
already great resources for learning how to use these tests effectively,
including the official [docs][test-doc], a fantastic [blog post][test-blog],
and the examples in [nixpkgs][nixos-tests].

[test-doc]: https://nixos.org/manual/nixos/stable/index.html#sec-nixos-tests
[test-blog]: https://www.haskellforall.com/2020/11/how-to-use-nixos-for-lightweight.html
[default]: https://github.com/divnix/devos/tree/core/tests/default.nix
[run-test]: https://github.com/NixOS/nixpkgs/blob/6571462647d7316aff8b8597ecdf5922547bf365/lib/debug.nix#L154-L166
[nixos-tests]: https://github.com/NixOS/nixpkgs/tree/master/nixos/tests
[testing-python]: https://github.com/NixOS/nixpkgs/tree/master/nixos/lib/testing-python.nix
[check]: https://nixos.org/manual/nixpkgs/stable/#ssec-check-phase
