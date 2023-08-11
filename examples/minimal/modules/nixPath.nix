{
  channel,
  inputs,
  ...
}: {
  nix.nixPath = [
    "nixpkgs=${channel.input}"
    "home-manager=${inputs.home-manager}"
  ];
}
