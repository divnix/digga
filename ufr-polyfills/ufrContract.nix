let
  eachSystem = import ./eachSystem.nix;
in

supportedSystems:
  imprt: inputs:
    eachSystem supportedSystems (system:
      import imprt {
        inherit inputs system; # The super stupid flakes contract `{ inputs, system }`
      }
    )
