{ system ? builtins.currentSystem
, inputs ? import ../ufr-polyfills/flake.lock.nix ./.
}:
let

  nixpkgs = inputs.nixpkgs;
  digga = inputs.digga;
  pkgs = import nixpkgs { inherit system; config = { }; overlays = [ ]; };

  docOptions = digga.lib.mkFlake.options { self = { }; inputs = { }; };
  evaledOptions = (pkgs.lib.evalModules { modules = [ docOptions ]; }).options;

  mkDocPartMd = part: title: intro:
    pkgs.writeText "api-reference-${part}.md" ''
      # ${title}
      ${intro}

      ${(
        pkgs.nixosOptionsDoc { options = evaledOptions.${part}; }
      ).optionsMDDoc}
    '';

in
{

  mkApiReferenceTopLevel = pkgs.writeText "api-reference.md" ''
    # Top Level API
    `digga`'s top level API. API Containers are documented in their respective sub-chapter:

    - [Channels](./api-reference-channels.md)
    - [Home](./api-reference-home.md)
    - [Devshell](./api-reference-devshell.md)
    - [NixOS](./api-reference-nixos.md)

    ${( pkgs.nixosOptionsDoc {
        options = {
          inherit (evaledOptions)
            channelsConfig
            self
            inputs
            outputsBuilder
            supportedSystems
          ;
        };
      }).optionsMDDoc}
  '';

  mkApiReferenceChannels = mkDocPartMd "channels" "Channels API Container" ''
    Configure your channels that you can use throughout your configurations.

    > #### ⚠ Gotcha ⚠
    > Devshell & (non-host-specific) Home-Manager `pkgs` instances are rendered off the
    > `nixos.hostDefaults.channelName` (default) channel.
  '';
  mkApiReferenceDevshell = mkDocPartMd "devshell" "Devshell API Container" ''
    Configure your devshell module collections of your environment.
  '';
  mkApiReferenceHome = mkDocPartMd "home" "Home-Manager API Container" ''
    Configure your home manager modules, profiles & suites.
  '';
  mkApiReferenceNixos = mkDocPartMd "nixos" "NixOS API Container" ''
    Configure your nixos modules, profiles & suites.
  '';

}
