{ nixos, ... }:
let
  inherit (builtins) attrNames attrValues isAttrs readDir listToAttrs mapAttrs
    pathExists filter;

  inherit (nixos.lib) fold filterAttrs hasSuffix mapAttrs' nameValuePair removeSuffix
    recursiveUpdate genAttrs nixosSystem mkForce;

  # mapFilterAttrs ::
  #   (name -> value -> bool )
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  mapFilterAttrs = seive: f: attrs: filterAttrs seive (mapAttrs' f attrs);

  # Generate an attribute set by mapping a function over a list of values.
  genAttrs' = values: f: listToAttrs (map f values);

  # pkgImport :: Nixpkgs -> Overlays -> System -> Pkgs
  pkgImport = nixpkgs: overlays: system:
    import nixpkgs {
      inherit system overlays;
      config = { allowUnfree = true; };
    };

  # Convert a list to file paths to attribute set
  # that has the filenames stripped of nix extension as keys
  # and imported content of the file as value.
  #
  pathsToImportedAttrs = paths:
    genAttrs' paths (path: {
      name = removeSuffix ".nix" (baseNameOf path);
      value = import path;
    });

  overlayPaths =
    let
      overlayDir = ../overlays;
      fullPath = name: overlayDir + "/${name}";
    in
    map fullPath (attrNames (readDir overlayDir));

  defaultImports = dir:
    let
      filtered = filterAttrs
        (n: v: v == "directory" && pathExists "${dir}/${n}/default.nix")
        (readDir dir);
    in
    mapAttrs
      (n: v: {
        default = import "${dir}/${n}/default.nix";
      } // defaultImports "${dir}/${n}")
      filtered;

in
{
  inherit defaultImports mapFilterAttrs genAttrs' pkgImport pathsToImportedAttrs;

  overlays = pathsToImportedAttrs overlayPaths;

  profileMap = map (profile: profile.default);

  recImport = { dir, _import ? base: import "${dir}/${base}.nix" }:
    mapFilterAttrs
      (_: v: v != null)
      (n: v:
        if n != "default.nix" && hasSuffix ".nix" n && v == "regular"
        then
          let name = removeSuffix ".nix" n; in nameValuePair (name) (_import name)
        else
          nameValuePair ("") (null))
      (readDir dir);

  nixosSystemExtended = { modules, ... } @ args:
    nixosSystem (args // {
      modules =
        let
          modpath = "nixos/modules";
          cd = "installer/cd-dvd/installation-cd-minimal-new-kernel.nix";
          ciConfig =
            (nixosSystem (args // {
              modules =
                let
                  # remove host module
                  modules' = filter (x: ! x ? require) modules;
                in
                modules' ++ [
                  ({ suites, ... }: {
                    imports = with suites;
                      allProfiles ++ allUsers;
                    security.mitigations.acceptRisk = true;

                    boot.loader.systemd-boot.enable = true;
                    boot.loader.efi.canTouchEfiVariables = true;

                    fileSystems."/" = { device = "/dev/disk/by-label/nixos"; };
                  })
                ];
            })).config;

          isoConfig = (nixosSystem
            (args // {
              modules = modules ++ [
                "${nixos}/${modpath}/${cd}"
                ({ config, ... }: {
                  isoImage.isoBaseName = "nixos-" + config.networking.hostName;
                  # confilcts with networking.wireless which might be slightly
                  # more useful on a stick
                  networking.networkmanager.enable = mkForce false;
                  # confilcts with networking.wireless
                  networking.wireless.iwd.enable = mkForce false;
                })
              ];
            })).config;
        in
        modules ++ [{
          system.build = {
            iso = isoConfig.system.build.isoImage;
            ci = ciConfig.system.build.toplevel;
          };
        }];
    });

  nixosModules =
    let
      # binary cache
      cachix = import ../cachix.nix;
      cachixAttrs = { inherit cachix; };

      # modules
      moduleList = import ../modules/list.nix;
      modulesAttrs = pathsToImportedAttrs moduleList;

    in
    recursiveUpdate cachixAttrs modulesAttrs;

  genHomeActivationPackages = hmConfigs:
    mapAttrs
      (_: x: mapAttrs
        (_: cfg: cfg.home.activationPackage)
        x)
      hmConfigs;

  genPackages = { self, pkgs }:
    let
      inherit (self) overlay overlays;
      packagesNames = attrNames (overlay null null)
        ++ attrNames (fold
        (attr: sum: recursiveUpdate sum attr)
        { }
        (attrValues
          (mapAttrs (_: v: v null null) overlays)
        )
      );
    in
    fold
      (key: sum: recursiveUpdate sum {
        ${key} = pkgs.${key};
      })
      { }
      packagesNames;
}
