{
  hostDefaults.channelName = "nixos";
  hosts = {
    Morty.modules = [ ./Morty.nix ];
  };
}
