# nvfetcher
[NvFetcher][nvf] is a workflow companion for updating nix sources.

You can specify an origin source and an update configuration, and
nvfetcher can for example track updates to a specific branch and
automatically update your nix sources configuration on each run
to the tip of that branch.

All package source declaration is done in [sources.toml][sources.toml].

From within the devshell of this repo, run `nvfetcher`, a wrapped
version of `nvfetcher` that knows where to find and place its files
and commit the results.

## Usage

Statically fetching (not tracking) a particular tag from a github repo:
```toml
[manix]
src.manual = "v0.6.3"
fetch.github = "mlvzk/manix"
```

Tracking the latest github _release_ from a github repo:
```toml
[manix]
src.github = "mlvzk/manix" # responsible for tracking
fetch.github = "mlvzk/manix" # responsible for fetching
```

Tracking the latest commit of a git repository and fetch from a git repo:
```toml
[manix]
src.git = "https://github.com/mlvzk/manix.git" # responsible for tracking
fetch.git = "https://github.com/mlvzk/manix.git" # responsible for fetching
```

> ##### _Note:_
> Please refer to the [NvFetcher Readme][nvf-readme] for more options.

[nvf]: https://github.com/berberman/nvfetcher
[nvf-readme]: https://github.com/berberman/nvfetcher#readme
[sources.toml]: https://github.com/divnix/devos/tree/main/pkgs/sources.toml
