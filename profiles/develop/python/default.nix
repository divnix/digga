{ pkgs, ... }:
let inherit (pkgs) python3Packages;
in {
  environment.systemPackages = let
    packages = pythonPackages:
      with pythonPackages; [
        numpy
        pandas
        ptpython
        requests
        scipy
      ];

    python = pkgs.python3.withPackages packages;

  in [ python ];
  environment.sessionVariables = {
    PYTHONSTARTUP = let
      startup = pkgs.writers.writePython3 "ptpython.py" {
        libraries = [ python3Packages.ptpython ];
      } ''
        import sys
        try:
            from ptpython.repl import embed
        except ImportError:
            print("ptpython is not available: falling back to standard prompt")
        else:
            sys.exit(embed(globals(), locals()))
      '';
    in "${startup}";
  };
}

