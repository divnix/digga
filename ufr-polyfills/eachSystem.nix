# Builds a map from value to <system>=value for each system.
# .. adopted from: https://github.com/numtide/flake-utils
#
systems: f:
let
  op = attrs: system:
    attrs // {
      ${system} = f system;
    };
in
builtins.foldl' op { } systems

