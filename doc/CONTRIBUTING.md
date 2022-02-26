# TL;DR;
- **Target Branch**: `main`
- **Merge Policy**: [`bors`][bors] is always right (&rarr; `bors try`)
- **Docs**: every change set is expected to contain doc updates
- **Commit Msg**: be a poet! Comprehensive and explanatory commit messages 
  should cover the motivation and use case in an easily understandable manner
  even when read after a few months.
- **Test Driven Development**: please default to test driven development you can
  make use of the `./examples` & `./e2e` and wire test up in the devshell. 

### Within the Devshell (`nix develop`)
- **Hooks**: please `git commit` within the devshell
- **Fail Early**: please run `check-all` from within the devshell on your local machine

[bors]: https://bors.tech

