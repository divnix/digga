{ channel, inputs, ... }: {
  nix.nixPath = [
    "nixpkgs=${channel.input}"
    "nixos-config=${../lib/compat/nixos}"
    "home-manager=${inputs.home}"
  ];
}
