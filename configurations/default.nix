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
            core = ../profiles/core.nix;

            global = {
              system.configurationRevision = flake.rev;

              networking.hostName = "${this}";

              nix.package = nix.defaultPackage."${system}";
            };

            local = ./. + "/${this}.nix";

          in
            [
              core
              global
              local
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
