{ lib, flake-utils-plus, internal-modules, importers, nixosModules }:
let
  importers' = importers;
in
lib.warn ''
  You are accessing a deprecated item of the digga lib.
  Please update timely, it will be remove soon.
''
rec {

  mkSuites = lib.warn ''
    Deprecated Function: mkSuites.
  ''
    (
      { suites, profiles }:
      let
        profileSet = lib.genAttrs' profiles (path: {
          name = baseNameOf path;
          value = mkProfileAttrs (toString path);
        });
      in
      lib.mapAttrs (_: v: lib.profileMap v) (suites profileSet)
    )
  ;

  mkProfileAttrs = lib.warn ''
    Deprecated Function: mkProfileAttrs.
  ''
    (
      dir:
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
            (lib.pathExists (dir + "/${n}/default.nix"))
            { default = dir + "/${n}"; }
          // mkProfileAttrs (dir + "/${n}");
      in
      lib.mapAttrs f imports
    )
  ;

  profileMap =
    lib.warn ''
      Deprecated Function: profileMap.
    ''
      (
        list: map (profile: profile.default) (lib.flatten list)
      )
  ;


  exporters =
    lib.warn ''
      Deprecated Attribute Set: lib.exporters.

      Please use export* functions instead:
        lib.exporters.modulesFromList  -> lib.exportModules
        lib.exporters.fromOverlays     -> lib.exportPackages
        lib.exporters.internalOverlays -> lib.exportOverlays
    ''
      {
        modulesFromList = flake-utils-plus.lib.exportModules;
        fromOverlays = flake-utils-plus.lib.exportPackages;
        internalOverlays = flake-utils-plus.lib.exportOverlays;
      }
  ;

  modules =
    lib.warn ''
      Deprecated Attribute Set: lib.modules.

      Internal modules 'customBuilds', 'hmNixosDefaults' & 'globalDefaults'
      will be completely removed from the api soon.

      Please use digga.nixosModules for exported modules or proto-modules:
        lib.modules.isoConfig -> nixosModules.boostrapIso
    ''
      (
        internal-modules // { isoConfig = nixosModules.boostrapIso; }
      )
  ;

  importModules =
    lib.warn ''
      Deprecated Function: lib.importModules.

      Use lib.importExportableModules instead to set `exportedModules` option
    ''
      importers'.importExportableModules;

  importers =
    lib.warn ''
      Deprecated Attribute Set: lib.importers.

      Please use import* functions instead:
        lib.importers.overlays    -> lib.importOverlays
        lib.importers.modules     -> lib.importModules
        lib.importers.hosts       -> lib.importHosts
        lib.importers.rakeLeaves  -> lib.rakeLeaves
        lib.importers.flattenTree -> lib.flattenTree
    ''
      {
        overlays = importers'.importOverlays;
        modules = importers'.importModules;
        hosts = importers'.importHosts;
        rakeLeaves = importers'.rakeLeaves;
        flattenTree = importers'.flattenTree;
      }
  ;

}
