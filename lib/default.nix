{ nixos, pkgs, ... }:
let
  inherit (builtins) attrNames attrValues isAttrs readDir listToAttrs mapAttrs
    pathExists filter;

  inherit (nixos.lib) fold filterAttrs hasSuffix mapAttrs' nameValuePair removeSuffix
    recursiveUpdate genAttrs nixosSystem mkForce substring optionalAttrs;

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
    let
      paths' = filter (hasSuffix ".nix") paths;
    in
    genAttrs' paths' (path: {
      name = removeSuffix ".nix" (baseNameOf path);
      value = import path;
    });

  overlayPaths =
    let
      overlayDir = ../overlays;
      fullPath = name: overlayDir + "/${name}";
    in
    map fullPath (attrNames (readDir overlayDir));

  /**
  Synopsis: mkNodes _nixosConfigurations_

  Generate the `nodes` attribute expected by deploy-rs
  where _nixosConfigurations_ are `nodes`.
  **/
  mkNodes = deploy: mapAttrs (_: config: {
    hostname = config.config.networking.hostName;

    profiles.system = {
      user = "root";
      path = deploy.lib.x86_64-linux.activate.nixos config;
    };
  });

  /**
  Synopsis: mkProfileAttrs _path_

  Recursively import the subdirs of _path_ containing a default.nix.

  Example:
  let profiles = mkProfileAttrs ./profiles; in
  assert profiles ? core.default; 0
  **/
  mkProfileAttrs = dir:
    let
      imports =
        let
          files = readDir dir;

          p = n: v:
            v == "directory"
            && n != "profiles";
        in
        filterAttrs p files;

      f = n: _:
        optionalAttrs
          (pathExists "${dir}/${n}/default.nix")
          { default = "${dir}/${n}"; }
        // mkProfileAttrs "${dir}/${n}";
    in
    mapAttrs f imports;

in
{
  inherit mkProfileAttrs mapFilterAttrs genAttrs' pkgImport
    pathsToImportedAttrs mkNodes;

  overlays = pathsToImportedAttrs overlayPaths;

  mkVersion = src: "${substring 0 8 src.lastModifiedDate}_${src.shortRev}";

  genPkgs = { self }:
    let inherit (self) inputs;
    in
    (inputs.utils.lib.eachDefaultSystem
      (system:
        let
          extern = import ../extern { inherit inputs; };
          overridePkgs = pkgImport inputs.override [ ] system;
          overridesOverlay = (import ../overrides).packages;

          overlays = [
            (overridesOverlay overridePkgs)
            self.overlay
            (final: prev: {
              srcs = self.inputs.srcs.inputs;
              lib = (prev.lib or { }) // {
                inherit (nixos.lib) nixosSystem;
                flk = self.lib;
                utils = inputs.utils.lib;
              };
            })
          ]
          ++ extern.overlays
          ++ (attrValues self.overlays);
        in
        { pkgs = pkgImport nixos overlays system; }
      )
    ).pkgs;

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
      moduleList = import ../modules/module-list.nix;
      modulesAttrs = pathsToImportedAttrs moduleList;

    in
    recursiveUpdate cachixAttrs modulesAttrs;

  genHomeActivationPackages = { self }:
    let hmConfigs =
      builtins.mapAttrs
        (_: config: config.config.home-manager.users)
        self.nixosConfigurations;
    in
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
