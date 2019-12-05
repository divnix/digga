{ nix, nixpkgs, flake, ... }:
let
  inherit (builtins)
    isAttrs
    readDir
    ;

  inherit (nixpkgs.lib)
    filterAttrs
    hasSuffix
    mapAttrs'
    nameValuePair
    removeSuffix
    ;


  configs = let
    configs' = let
      config = this:
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";

          modules = let
            coreConfig = ../profiles/core.nix;

            globalConfig = {
              system.configurationRevision = flake.rev;

              networking.hostName = "${this}";

              nix.package = nix.defaultPackage."${system}";
            };

            thisConfig = ./. + "/${this}.nix";

          in
            [
              coreConfig
              globalConfig
              thisConfig
            ];

        };

      dot = readDir ./.;

    in
      mapAttrs'
        (
          name: value:
            if
              name != "default.nix"
              && hasSuffix ".nix" name
              && value == "regular"

            then let
              name' = removeSuffix ".nix" name;
            in
              nameValuePair (name') (config name')

            else
              nameValuePair ("") (null)
        )
        dot;

    removeInvalid =
      filterAttrs (_: value: isAttrs value);
  in
    removeInvalid configs';

in
configs
