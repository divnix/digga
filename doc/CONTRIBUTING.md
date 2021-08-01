# Pull Requests

## TL;DR;
- **Target Branch**: `main`
- **Merge Policy**: [`bors`][bors] is alwyas right (&rarr; `bors try`)
- **Docs**: every changeset is expected to contain doc updates
- **Commit Msg**: be a poet! Comprehensive and explanatory commit messages 
  should cover the motivation and use case in an easily understandable manner
  even when read after a few months.
- **Test Driven Development**: please default to test driven development where possible.

### Within the Devshell (`nix develop`)
- **Hooks**: please `git commit` within the devshell
- **Fail Early**: please run from within the devshell on your local machine:
  - `nix flake check`

[bors]: https://bors.tech

