{ nixos, pkgs, ... }:
let
  inherit (nixos) lib;
  # mapFilterAttrs ::
  #   (name -> value -> bool )
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  mapFilterAttrs = seive: f: attrs:
    lib.filterAttrs
      seive
      (lib.mapAttrs' f attrs);

  # Generate an attribute set by mapping a function over a list of values.
  genAttrs' = values: f: lib.listToAttrs (map f values);

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
      paths' = lib.filter (lib.hasSuffix ".nix") paths;
    in
    genAttrs' paths' (path: {
      name = lib.removeSuffix ".nix" (baseNameOf path);
      value = import path;
    });

  overlayPaths =
    let
      overlayDir = ../overlays;
      fullPath = name: overlayDir + "/${name}";
    in
    map fullPath (lib.attrNames (builtins.readDir overlayDir));

  /**
  Synopsis: mkNodes _nixosConfigurations_

  Generate the `nodes` attribute expected by deploy-rs
  where _nixosConfigurations_ are `nodes`.
  **/
  mkNodes = deploy: lib.mapAttrs (_: config: {
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
          files = builtins.readDir dir;

          p = n: v:
            v == "directory"
            && n != "profiles";
        in
        lib.filterAttrs p files;

      f = n: _:
        lib.optionalAttrs
          (lib.pathExists "${dir}/${n}/default.nix")
          { default = "${dir}/${n}"; }
        // mkProfileAttrs "${dir}/${n}";
    in
    lib.mapAttrs f imports;

in
{
  inherit mkProfileAttrs mapFilterAttrs genAttrs' pkgImport
    pathsToImportedAttrs mkNodes;

  overlays = pathsToImportedAttrs overlayPaths;

  mkVersion = src: "${lib.substring 0 8 src.lastModifiedDate}_${src.shortRev}";

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
                inherit (lib) nixosSystem;

                dev = self.lib;
                utils = inputs.utils.lib;
              };
            })
          ]
          ++ extern.overlays
          ++ (lib.attrValues self.overlays);
        in
        { pkgs = pkgImport nixos overlays system; }
      )
    ).pkgs;

  profileMap = map (profile: profile.default);

  recImport = { dir, _import ? base: import "${dir}/${base}.nix" }:
    mapFilterAttrs
      (_: v: v != null)
      (n: v:
        if n != "default.nix" && lib.hasSuffix ".nix" n && v == "regular"
        then
          let name = lib.removeSuffix ".nix" n; in lib.nameValuePair (name) (_import name)
        else
          lib.nameValuePair ("") (null))
      (builtins.readDir dir);

  nixosSystemExtended = { modules, ... } @ args:
    lib.nixosSystem (args // {
      modules =
        let
          modpath = "nixos/modules";
          cd = "installer/cd-dvd/installation-cd-minimal-new-kernel.nix";
          ciConfig =
            (lib.nixosSystem (args // {
              modules =
                let
                  # remove host module
                  modules' = lib.filter (x: ! x ? require) modules;
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

          isoConfig = (lib.nixosSystem
            (args // {
              modules = modules ++ [
                "${nixos}/${modpath}/${cd}"
                ({ config, ... }: {
                  isoImage.isoBaseName = "nixos-" + config.networking.hostName;
                  # confilcts with networking.wireless which might be slightly
                  # more useful on a stick
                  networking.networkmanager.enable = lib.mkForce false;
                  # confilcts with networking.wireless
                  networking.wireless.iwd.enable = lib.mkForce false;
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
    lib.recursiveUpdate cachixAttrs modulesAttrs;

  genHomeActivationPackages = { self }:
    let hmConfigs =
      lib.mapAttrs
        (_: config: config.config.home-manager.users)
        self.nixosConfigurations;
    in
    lib.mapAttrs
      (_: x: lib.mapAttrs
        (_: cfg: cfg.home.activationPackage)
        x)
      hmConfigs;

  genPackages = { self, pkgs }:
    let
      inherit (self) overlay overlays;
      packagesNames = lib.attrNames (overlay null null)
        ++ lib.attrNames (lib.fold
        (attr: sum: lib.recursiveUpdate sum attr)
        { }
        (lib.attrValues
          (lib.mapAttrs (_: v: v null null) overlays)
        )
      );
    in
    lib.fold
      (key: sum: lib.recursiveUpdate sum {
        ${key} = pkgs.${key};
      })
      { }
      packagesNames;
}
