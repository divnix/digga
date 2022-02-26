# Hercules CI
If you start adding your own packages and configurations, you'll probably have
at least a few binary artifacts. With hercules we can build every package in
our configuration automatically, on every commit. Additionally, we can have it
upload all our build artifacts to a binary cache like [cachix][cachix].

This will work whether your copy is a fork, or a bare template, as long as your
repo is hosted on GitHub.

## Setup
Just head over to [hercules-ci.com](https://hercules-ci.com) to make an account.

Then follow the docs to set up an [agent][agent], if you want to deploy to a
binary cache (and of course you do), be sure _not_ to skip the
[binary-caches.json][cache].

## Ready to Use
The repo is already set up with the proper _default.nix_ file, building all
declared packages, checks, profiles and shells. So you can see if something
breaks, and never build the same package twice!

If you want to get fancy, you could even have hercules
[deploy your configuration](https://docs.hercules-ci.com/hercules-ci-effects/guide/deploy-a-nixos-machine/)!

> ##### _Note:_
> Hercules doesn't have access to anything encrypted in the
> [secrets folder](../../secrets), so none of your secrets will accidentally get
> pushed to a cache by mistake.
>
> You could pull all your secrets via your user, and then exclude it from
> [allUsers](https://github.com/nrdxp/devos/blob/nrd/suites/default.nix#L17)
> to keep checks passing.

[agent]: https://docs.hercules-ci.com/hercules-ci/getting-started/#github
[cache]: https://docs.hercules-ci.com/hercules-ci/getting-started/deploy/nixos/#_3_configure_a_binary_cache
[cachix]: https://cachix.org
