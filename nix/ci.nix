let
  inherit (default.inputs.nixos) lib;

  default = (import "${../.}/compat").defaultNix;

  ciSystems = [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
  ];

  filterSystems = lib.filterAttrs
    (system: _: lib.elem system ciSystems);

  recurseIntoAttrsRecursive = lib.mapAttrs (_: v:
    if lib.isAttrs v
    then recurseIntoAttrsRecursive (lib.recurseIntoAttrs v)
    else v
  );

  systemOutputs = lib.filterAttrs
    (_: set: lib.isAttrs set
      && lib.any
      (system: set ? ${system})
      ciSystems
    )
    default.outputs;

  ciDrvs = lib.mapAttrs (_: system: filterSystems system) systemOutputs;
in
recurseIntoAttrsRecursive ciDrvs
